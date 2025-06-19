<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: anhnn
  Date: 14/06/2025
  Time: 10:00 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <jsp:include page="./common/headload.jsp"/>
    <title>Create New Quiz</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Select2 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet"/>

    <!-- Select2 Bootstrap 5 Theme -->
    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/select2-bootstrap-5-theme@1.3.0/dist/select2-bootstrap-5-theme.min.css"/>

    <!-- jQuery (phải load trước Select2) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>

    <!-- Select2 JavaScript -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>

    <style>
        .section-divider {
            border-left: 4px solid #0d6efd;
            padding-left: 15px;
            margin: 20px 0;
        }
        .form-container {
            background: #f8f9fa;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 15px rgba(0,0,0,0.1);
        }
        .quiz-setting-group {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            background: white;
        }
        .remove-group-btn {
            position: absolute;
            top: 10px;
            right: 10px;
        }
    </style>
</head>
<body>
<!-- Navbar-->
<jsp:include page="./layout/manage/header.jsp"/>

<%--User profile--%>
<jsp:include page="./user_profile.jsp"/>
<button onclick="window.history.back(); return false;" class="btn btn-outline-secondary"
        style="position: fixed; left: 50px; top: 100px; z-index: 1000;">
    <i class="bi bi-arrow-left"></i> Back
</button>

<div class="container" style="margin-top: 100px; max-width: 800px;">
    <div class="form-container">
        <h2 class="text-center mb-4">Create New Quiz</h2>

        <form id="quizForm" method="POST" action="create_quiz">
            <!-- Basic Quiz Information -->
            <div class="section-divider">
                <h5 class="text-primary mb-3">Basic Information</h5>

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label for="name" class="form-label">Quiz Name</label>
                        <input type="text" class="form-control" id="name" name="name"
                               placeholder="Enter quiz name" required>
                    </div>

                    <div class="col-md-6 mb-3">
                        <label for="subjectId" class="form-label">Subject</label>
                        <select class="form-select" id="subjectId" name="subjectId" required>
                            <option value="" selected disabled>Select subject</option>
                            <c:forEach var="subject" items="${requestScope.subjects}">
                                <option value="${subject.getId()}">${subject.getName()}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-4 mb-2">
                        <label for="level" class="form-label">Quiz Level</label>
                        <select class="form-select" id="level" name="level" required>
                            <option value="" selected disabled>Select level</option>
                            <option value="Easy">Easy</option>
                            <option value="Medium">Medium</option>
                            <option value="Hard">Hard</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-2">
                        <label for="format" class="form-label">Quiz Format</label>
                    <select class="form-select" id="format" name="format" required>
                        <option value="" selected disabled>Select quiz format</option>
                        <option value="Multiple">Multiple</option>
                        <option value="Essay">Essay</option>
                    </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label for="duration" class="form-label">Duration (minutes)</label>
                        <input type="number" class="form-control" id="duration" name="duration"
                               min="1" placeholder="Enter duration" required>
                    </div>

                    <div class="col-md-4 mb-3">
                        <label for="passRate" class="form-label">Pass Rate (%)</label>
                        <input type="number" class="form-control" id="passRate" name="passRate"
                               min="1" max="100" placeholder="Enter pass rate" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label for="testTypeId" class="form-label">Test Type</label>
                    <select class="form-select" id="testTypeId" name="testTypeId" required>
                        <option value="" selected disabled>Select test type</option>
                        <c:forEach var="testType" items="${requestScope.testTypes}">
                            <option value="${testType.getId()}">${testType.getName()}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="mb-3">
                    <label for="description" class="form-label">Description</label>
                    <textarea class="form-control" id="description" name="description" rows="3"
                              placeholder="Enter quiz description" required></textarea>
                </div>
            </div>

            <!-- Quiz Settings -->
            <div class="section-divider">
                <h5 class="text-primary mb-3">Quiz Settings</h5>

                <div class="mb-3">
                    <label class="form-label d-block mb-2">Questions are selected by:</label>
                    <div class="form-check form-check-inline" style="margin-right: 100px">
                        <label class="form-check-label" for="byDimension">Dimension</label>
                        <input class="form-check-input" type="radio" name="questionType"
                               id="byDimension" value="dimension" checked>
                    </div>
                    <div class="form-check form-check-inline">
                        <label class="form-check-label" for="byLesson">Lesson</label>
                        <input class="form-check-input" type="radio" name="questionType"
                               id="byLesson" value="lesson">
                    </div>
                </div>

                <!-- Quiz Setting Groups Container -->
                <div id="quizSettingGroups">
                    <div class="quiz-setting-group position-relative" data-group-index="0">
                        <button type="button" class="btn btn-sm btn-outline-danger remove-group-btn d-none">
                            <i class="bi bi-x"></i>
                        </button>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label">Number of Questions</label>
                                <input type="number" class="form-control group-questions"
                                       name="groupQuestions[]" min="1" required>
                            </div>

                            <div class="col-md-8 mb-3">
                                <div class="dimension-section">
                                    <label class="form-label">Dimension</label>
                                    <select class="form-select group-dimension" name="groupDimensions[]" required>
                                        <option value="" disabled selected>Select dimension</option>
                                    </select>
                                </div>

                                <div class="lesson-section d-none">
                                    <label class="form-label">Lesson</label>
                                    <select class="form-select group-lesson" name="groupLessons[]">
                                        <option value="" disabled selected>Select lesson</option>
                                    </select>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="text-center mb-3">
                    <button type="button" id="addGroupBtn" class="btn btn-outline-primary">
                        <i class="bi bi-plus"></i> Add Question Group
                    </button>
                </div>

                <div class="mb-3">
                    <label class="form-label">Total Questions: <span id="totalQuestions" class="text-primary">0</span></label>
                </div>
            </div>

            <div class="d-grid gap-2 mt-4">
                <button type="submit" class="btn btn-primary w-100 p-2">Create Quiz</button>
            </div>
        </form>
    </div>
</div>

<script>
    let groupIndex = 0;

    const dimensionRadioBtn = document.getElementById("byDimension");
    const lessonRadioBtn = document.getElementById("byLesson");
    const subjectSelect = document.getElementById("subjectId");
    const addGroupBtn = document.getElementById("addGroupBtn");
    const quizSettingGroups = document.getElementById("quizSettingGroups");
    const totalQuestionsSpan = document.getElementById("totalQuestions");

    // Initialize arrays for dimensions and lessons
    const allDimensions = [];
    <c:forEach var="dimension" items="${requestScope.dimensions}">
    allDimensions.push({
        id: ${dimension.getId()},
        name: "${dimension.getName()}",
        subjectId: ${dimension.getSubjectId()}
    });
    </c:forEach>

    const allLessons = [];
    <c:forEach var="lesson" items="${requestScope.lessons}">
    allLessons.push({
        id: ${lesson.id},
        name: "${lesson.name}",
        subjectId: ${lesson.subjectId}
    });
    </c:forEach>

    // Toggle between dimension and lesson selection
    function toggleQuestionType() {
        const isDimension = dimensionRadioBtn.checked;
        const groups = document.querySelectorAll('.quiz-setting-group');

        groups.forEach(group => {
            const dimensionSection = group.querySelector('.dimension-section');
            const lessonSection = group.querySelector('.lesson-section');
            const dimensionSelect = group.querySelector('.group-dimension');
            const lessonSelect = group.querySelector('.group-lesson');

            if (isDimension) {
                dimensionSection.classList.remove('d-none');
                lessonSection.classList.add('d-none');
                dimensionSelect.setAttribute('required', '');
                lessonSelect.removeAttribute('required');
            } else {
                lessonSection.classList.remove('d-none');
                dimensionSection.classList.add('d-none');
                lessonSelect.setAttribute('required', '');
                dimensionSelect.removeAttribute('required');
            }
        });
    }

    dimensionRadioBtn.addEventListener("change", toggleQuestionType);
    lessonRadioBtn.addEventListener("change", toggleQuestionType);

    // Update dimension and lesson options when subject changes
    subjectSelect.addEventListener("change", (e) => {
        const subjectId = parseInt(e.target.value);
        updateAllGroupSelections(subjectId);
    });

    function updateAllGroupSelections(subjectId) {
        const groups = document.querySelectorAll('.quiz-setting-group');

        groups.forEach(group => {
            const dimensionSelect = group.querySelector('.group-dimension');
            const lessonSelect = group.querySelector('.group-lesson');

            // Clear existing options
            dimensionSelect.innerHTML = "<option value='' disabled selected>Select dimension</option>";
            lessonSelect.innerHTML = "<option value='' disabled selected>Select lesson</option>";

            // Add filtered dimensions
            const filteredDims = allDimensions.filter(d => d.subjectId === subjectId);
            filteredDims.forEach(d => {
                const opt = document.createElement("option");
                opt.value = d.id;
                opt.text = d.name;
                dimensionSelect.appendChild(opt);
            });

            // Add filtered lessons
            const filteredLessons = allLessons.filter(l => l.subjectId === subjectId);
            filteredLessons.forEach(l => {
                const opt = document.createElement("option");
                opt.value = l.id;
                opt.text = l.name;
                lessonSelect.appendChild(opt);
            });
        });
    }

    // Add new question group
    addGroupBtn.addEventListener("click", () => {
        groupIndex++;
        const newGroup = createQuestionGroup(groupIndex);
        quizSettingGroups.appendChild(newGroup);

        // Update subject-related options if subject is selected
        if (subjectSelect.value) {
            updateAllGroupSelections(parseInt(subjectSelect.value));
        }

        toggleQuestionType();
        updateRemoveButtons();
        updateTotalQuestions();
    });

    function createQuestionGroup(index) {
        const groupDiv = document.createElement('div');
        groupDiv.className = 'quiz-setting-group position-relative';
        groupDiv.setAttribute('data-group-index', index);

        groupDiv.innerHTML = `
            <button type="button" class="btn btn-sm btn-outline-danger remove-group-btn">
                <i class="bi bi-x"></i>
            </button>

            <div class="row">
                <div class="col-md-4 mb-3">
                    <label class="form-label">Number of Questions</label>
                    <input type="number" class="form-control group-questions"
                           name="groupQuestions[]" min="1" required>
                </div>

                <div class="col-md-8 mb-3">
                    <div class="dimension-section">
                        <label class="form-label">Dimension</label>
                        <select class="form-select group-dimension" name="groupDimensions[]" required>
                            <option value="" disabled selected>Select dimension</option>
                        </select>
                    </div>

                    <div class="lesson-section d-none">
                        <label class="form-label">Lesson</label>
                        <select class="form-select group-lesson" name="groupLessons[]">
                            <option value="" disabled selected>Select lesson</option>
                        </select>
                    </div>
                </div>
            </div>
        `;

        // Add event listeners
        const removeBtn = groupDiv.querySelector('.remove-group-btn');
        const questionsInput = groupDiv.querySelector('.group-questions');

        removeBtn.addEventListener('click', () => {
            groupDiv.remove();
            updateRemoveButtons();
            updateTotalQuestions();
        });

        questionsInput.addEventListener('input', updateTotalQuestions);

        return groupDiv;
    }

    function updateRemoveButtons() {
        const groups = document.querySelectorAll('.quiz-setting-group');
        groups.forEach((group, index) => {
            const removeBtn = group.querySelector('.remove-group-btn');
            if (groups.length > 1) {
                removeBtn.classList.remove('d-none');
            } else {
                removeBtn.classList.add('d-none');
            }
        });
    }

    function updateTotalQuestions() {
        const questionsInputs = document.querySelectorAll('.group-questions');
        let total = 0;

        questionsInputs.forEach(input => {
            const value = parseInt(input.value) || 0;
            total += value;
        });

        totalQuestionsSpan.textContent = total;
    }

    // Add event listener to initial group
    document.querySelector('.group-questions').addEventListener('input', updateTotalQuestions);

    // Prevent selection before subject is chosen
    document.addEventListener('click', (e) => {
        if ((e.target.classList.contains('group-dimension') || e.target.classList.contains('group-lesson'))
            && !subjectSelect.value) {
            e.preventDefault();
            alert("Vui lòng chọn Subject trước khi chọn Dimensi on/Lesson");
            e.target.blur();
        }
    });

    // Form validation
    document.getElementById("quizForm").addEventListener("submit", function (e) {
        // Validate quiz name
        const nameInputElement = document.getElementById("name");
        const nameValue = nameInputElement.value.trim();
        if (nameValue === "") {
            e.preventDefault();
            nameInputElement.classList.add("is-invalid");
            if (!document.getElementById("name-error")) {
                const errorDiv = document.createElement("div");
                errorDiv.id = "name-error";
                errorDiv.classList.add("text-danger", "mt-1");
                errorDiv.textContent = "Quiz name cannot be empty or just spaces.";
                nameInputElement.parentNode.appendChild(errorDiv);
            }
            return;
        }

        // Validate total questions > 0
        const total = parseInt(totalQuestionsSpan.textContent);
        if (total === 0) {
            e.preventDefault();
            alert("Total number of questions must be greater than 0");
            return;
        }

        // Validate all groups have required fields
        const groups = document.querySelectorAll('.quiz-setting-group');
        let hasError = false;

        groups.forEach(group => {
            const questionsInput = group.querySelector('.group-questions');
            const isDimension = dimensionRadioBtn.checked;
            const selectElement = isDimension ?
                group.querySelector('.group-dimension') :
                group.querySelector('.group-lesson');

            if (!questionsInput.value || parseInt(questionsInput.value) <= 0) {
                questionsInput.classList.add('is-invalid');
                hasError = true;
            }

            if (!selectElement.value) {
                selectElement.classList.add('is-invalid');
                hasError = true;
            }
        });

        if (hasError) {
            e.preventDefault();
            alert("Please fill all required fields in question groups");
        }
    });
</script>
</body>
</html>