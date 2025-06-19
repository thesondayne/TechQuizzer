package controller;

import dao.*;
import dto.QuizDTO;
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

@WebServlet(name = "GetQuizzesDetailServlet", urlPatterns = {"/get-quiz-detail"})
public class GetQuizzesDetailServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        UserDTO user = (UserDTO) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        String action = request.getParameter("action");
        switch (action) {
            case "view":
                String idParam = request.getParameter("id");
                int id = Integer.parseInt(idParam);
                QuizDAO quizDAO = new QuizDAO();
                QuizDTO quiz = quizDAO.findByQuizId(id);

                DimensionDAO dimensionDAO = new DimensionDAO();
                LessonDAO lessonDAO = new LessonDAO();
                QuizSettingDAO quizSettingDAO = new QuizSettingDAO(); // Assuming this exists

                List<Dimension> dimensions = dimensionDAO.selectAllDimension(quiz.getSubject().getId());
                List<Lesson> lessons = lessonDAO.selectAllLesson(quiz.getSubject().getId());

                // Lấy danh sách question groups hiện tại
                int quizSettingId = quiz.getQuizSetting().getId();
                List<QuizSettingGroup> listLessonQuestion = quizSettingDAO.listLessonQuestion(quizSettingId);
                List<QuizSettingGroup> listDimensionQuestion = quizSettingDAO.listDimensionQuestion(quizSettingId);

                // Xác định loại quiz setting hiện tại
                String currentQuizType = "";
                if (!listLessonQuestion.isEmpty()) {
                    currentQuizType = "lesson";
                } else if (!listDimensionQuestion.isEmpty()) {
                    currentQuizType = "dimension";
                }
                boolean hasAttempt = false;
                try {
                    hasAttempt = quizDAO.hasExamAttempt(id);
                } catch (Exception e) {
                    throw new RuntimeException(e);
                }

                request.setAttribute("hasAttempt", hasAttempt);
                request.setAttribute("dimensions", dimensions);
                request.setAttribute("lessons", lessons);
                request.setAttribute("quiz", quiz);
                request.setAttribute("listLessonQuestion", listLessonQuestion);
                request.setAttribute("listDimensionQuestion", listDimensionQuestion);
                request.setAttribute("currentQuizType", currentQuizType);

                request.getRequestDispatcher("quiz_detail.jsp").forward(request, response);
                break;
            default:
                response.sendRedirect("quizzeslist");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        switch (action) {
            case "update":
                try {
                    int id = Integer.parseInt(request.getParameter("id"));
                    int duration = Integer.parseInt(request.getParameter("duration"));
                    int passRate = Integer.parseInt(request.getParameter("passRate"));
                    int numberOfQuestions = Integer.parseInt(request.getParameter("numberOfQuestions"));

                    QuizDAO quizDAO = new QuizDAO();
                    QuizDTO quiz = quizDAO.findByQuizId(id);
                    String testType = request.getParameter("testTypeId");
                    int testTypeId = Integer.parseInt(testType);
                    quizDAO.updateQuiz(id, request.getParameter("name"), request.getParameter("level"), duration*60, passRate,testTypeId);

                    QuizSettingDAO quizSettingDAO = new QuizSettingDAO();
                    quizSettingDAO.updateQuizSetting(quiz.getQuizSetting().getId(), numberOfQuestions);

                    SubjectDAO subjectDAO = new SubjectDAO();
                    subjectDAO.updateSubjectName(quiz.getSubject().getId(), request.getParameter("subject"));

                    quiz = quizDAO.findByQuizId(id);
                    request.setAttribute("quiz", quiz);
                    request.getSession().setAttribute("message", "Update successful.");
                    request.getRequestDispatcher("quiz_detail.jsp").forward(request, response);
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Invalid number input.");
                    request.getRequestDispatcher("quiz_detail.jsp").forward(request, response);
                }
                break;
            default:
                response.sendRedirect("quizzeslist");
        }
    }
}
