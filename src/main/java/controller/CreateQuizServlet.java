package controller;

import dao.*;
import dto.UserDTO;
import entity.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "CreateQuizServlet", urlPatterns = {"/create_quiz"})
public class CreateQuizServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            SubjectDAO subjectDAO = new SubjectDAO();
            DimensionDAO dimensionDAO = new DimensionDAO();
            LessonDAO lessonDAO = new LessonDAO();
            TestTypeDAO testTypeDAO = new TestTypeDAO();
            // Load all subjects that user has access to (based on registrations)
            List<Subject> subjects = subjectDAO.getAllSubjects(user.getId());

            // Load all dimensions for all subjects (will be filtered by JavaScript)
            List<Dimension> dimensions = new ArrayList<>();
            List<Lesson> lessons = new ArrayList<>();

            for (Subject subject : subjects) {
                dimensions.addAll(dimensionDAO.selectAllDimension(subject.getId()));
                lessons.addAll(lessonDAO.selectAllLesson(subject.getId()));
            }

            // Load test types
            List<TestType> testTypes = testTypeDAO.getAllTestTypes();

            // Set attributes for JSP
            request.setAttribute("subjects", subjects);
            request.setAttribute("dimensions", dimensions);
            request.setAttribute("lessons", lessons);
            request.setAttribute("testTypes", testTypes);

            request.getRequestDispatcher("quiz_create.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");
        SubjectDAO subjectDAO = new SubjectDAO();
        DimensionDAO dimensionDAO = new DimensionDAO();
        LessonDAO lessonDAO = new LessonDAO();
        TestTypeDAO testTypeDAO = new TestTypeDAO();
        QuizSettingDAO quizSettingDAO = new QuizSettingDAO();
        QuizSettingGroupDAO quizSettingGroupDAO = new QuizSettingGroupDAO();
        QuizDAO quizDAO = new QuizDAO();
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Get basic quiz information
            String name = request.getParameter("name");
            int subjectId = Integer.parseInt(request.getParameter("subjectId"));
            String level = request.getParameter("level");
            String format = request.getParameter("format");
            int duration = Integer.parseInt(request.getParameter("duration"));
            int passRate = Integer.parseInt(request.getParameter("passRate"));
            int testTypeId = Integer.parseInt(request.getParameter("testTypeId"));
            String description = request.getParameter("description");
            String questionType = request.getParameter("questionType");

            // Validate basic information
            if (name == null || name.trim().isEmpty()) {
                throw new IllegalArgumentException("Quiz name cannot be empty");
            }

            if (duration <= 0 || passRate <= 0 || passRate > 100) {
                throw new IllegalArgumentException("Invalid duration or pass rate");
            }

            // Get question groups data
            String[] groupQuestions = request.getParameterValues("groupQuestions[]");
            String[] groupDimensions = null;
            String[] groupLessons = null;

            if ("dimension".equals(questionType)) {
                groupDimensions = request.getParameterValues("groupDimensions[]");
            } else {
                groupLessons = request.getParameterValues("groupLessons[]");
            }

            // Validate groups
            if (groupQuestions == null || groupQuestions.length == 0) {
                throw new IllegalArgumentException("At least one question group is required");
            }

            // Calculate total questions
            int totalQuestions = 0;
            List<QuizSettingGroup> settingGroups = new ArrayList<>();

            for (int i = 0; i < groupQuestions.length; i++) {
                int numQuestions = Integer.parseInt(groupQuestions[i]);
                if (numQuestions <= 0) {
                    throw new IllegalArgumentException("Number of questions must be greater than 0");
                }

                totalQuestions += numQuestions;
                QuizSettingGroup group = new QuizSettingGroup();
                group.setNumberQuestion(numQuestions);

                if ("dimension".equals(questionType)) {
                    if (groupDimensions == null || i >= groupDimensions.length ||
                            groupDimensions[i] == null || groupDimensions[i].isEmpty()) {
                        throw new IllegalArgumentException("Dimension must be selected for all groups");
                    }
                    group.setSubjectDimensionId(Integer.parseInt(groupDimensions[i]));
                } else {
                    if (groupLessons == null || i >= groupLessons.length ||
                            groupLessons[i] == null || groupLessons[i].isEmpty()) {
                        throw new IllegalArgumentException("Lesson must be selected for all groups");
                    }
                    group.setSubjectLessonId(Integer.parseInt(groupLessons[i]));
                }

                settingGroups.add(group);
            }

            if (totalQuestions == 0) {
                throw new IllegalArgumentException("Total questions must be greater than 0");
            }

            QuizSetting quizSetting = new QuizSetting();
            quizSetting.setNumberOfQuestions(totalQuestions);
            quizSetting.setQuestionType(questionType);

            int quizSettingId = quizSettingDAO.createQuizSetting(quizSetting);

            // Create quiz setting groups
            for (QuizSettingGroup group : settingGroups) {
                group.setQuizSettingId(quizSettingId);
                quizSettingGroupDAO.createQuizSettingGroup(group);
            }

            Quiz quiz = new Quiz();
            quiz.setName(name.trim());
            quiz.setLevel(level);
            quiz.setFormat(format);
            quiz.setDuration(duration*60);
            quiz.setPassRate(passRate);
            quiz.setDescription(description);
            quiz.setStatus(1); // Default active
            quiz.setTestTypeId(testTypeId);
            quiz.setSubjectId(subjectId);
            quiz.setQuizSettingId(quizSettingId);

            quizDAO.createQuiz(quiz);

            // Success - redirect to quiz list or quiz detail
            session.setAttribute("successMessage", "Quiz created successfully!");
            response.sendRedirect(request.getContextPath() + "/quizzeslist");

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Invalid number format: " + e.getMessage());
            doGet(request, response);
        } catch (IllegalArgumentException e) {
            request.setAttribute("errorMessage", e.getMessage());
            doGet(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Database error: " + e.getMessage());
            doGet(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Unexpected error: " + e.getMessage());
            doGet(request, response);
        }
    }
}
