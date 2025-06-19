<%--
  Created by IntelliJ IDEA.
  User: LAM
  Date: 29/05/2025
  Time: 6:01 CH
  To change this template use File | Settings | File Templates.
--%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
  <jsp:include page="./common/headload.jsp"/>
  <title>Quiz Overview</title>
  <style>
    .tab {
      overflow: hidden;
      border-bottom: 1px solid #ccc;
      background-color: #f1f1f1;
    }

    .tab button {
      background-color: inherit;
      border: none;
      outline: none;
      padding: 10px 20px;
      cursor: pointer;
      transition: 0.3s;
      font-weight: bold;
    }

    .tab button.active {
      border-bottom: 2px solid #004e00;
      background-color: #fff;
    }

    .tabcontent {
      display: none;
      padding: 20px;
      border: 1px solid #ccc;
      border-top: none;
    }

    .tabcontent.active {
      display: block;
    }

    .form-check {
      margin-right: 30px;
    }

    .btn-group-container {
      display: flex;
      gap: 10px;
      margin-top: 20px;
    }
    .disabled-overlay {
      pointer-events: none; /* Disable editing */
    }
  </style>

  <script>
    function openTab(evt, tabName) {
      var tabcontent = document.getElementsByClassName("tabcontent");
      for (var i = 0; i < tabcontent.length; i++) {
        tabcontent[i].classList.remove("active");
      }

      var tablinks = document.getElementsByClassName("tablink");
      for (var i = 0; i < tablinks.length; i++) {
        tablinks[i].classList.remove("active");
      }

      document.getElementById(tabName).classList.add("active");
      evt.currentTarget.classList.add("active");
    }

    window.onload = function () {
      document.getElementById("defaultOpen").click();
    };
  </script>
</head>
<body class="app sidebar-mini">
<jsp:include page="./layout/manage/header.jsp"/>

<!-- Sidebar menu-->
<jsp:include page="./layout/manage/sidebar.jsp">
  <jsp:param name="currentPage" value="quiz"/>
</jsp:include>
<%--User profile--%>
<jsp:include page="./user_profile.jsp"/>
<main class="app-content">
  <div class="app-title">
    <div>
      <h1><i class="bi bi-pencil-square"></i>Overview/Setting</h1>
    </div>
    <ul class="app-breadcrumb breadcrumb">
      <li class="breadcrumb-item"><a href="quizzeslist">Quizzes List</a></li>
      <li class="breadcrumb-item active">Overview/Setting</li>
    </ul>
  </div>

  <div class="tab">
    <button class="tablink" id="defaultOpen" onclick="openTab(event, 'Overview')">Overview</button>
    <button class="tablink" onclick="openTab(event, 'Setting')">Setting</button>
  </div>

  <!-- Overview Tab -->
  <div id="Overview" class="row tabcontent">
    <div class="col-md-8 offset-md-2">
      <div class="tile">
        <div class="tile-body ${hasAttempt ? 'disabled-overlay' : ''}">

          <c:if test="${hasAttempt}">
            <div class="alert alert-warning" role="alert">
              <i class="bi bi-exclamation-triangle"></i>
              This quiz has already been attempted and cannot be edited.
            </div>
          </c:if>
          <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success" role="alert">
                ${sessionScope.message}
            </div>
            <c:remove var="message" scope="session"/>
          </c:if>
          <c:if test="${not empty sessionScope.settingMessage}">
            <div class="alert alert-success" role="alert">
                ${sessionScope.settingMessage}
            </div>
            <c:remove var="settingMessage" scope="session"/>
          </c:if>
          <c:if test="${not empty sessionScope.settingErrorMessage}">
            <div class="alert alert-warning" role="alert">
                ${sessionScope.settingErrorMessage}
            </div>
            <c:remove var="settingErrorMessage" scope="session"/>
          </c:if>
          <form action="get-quiz-detail" method="post">
            <input type="hidden" name="action" value="update">
            <input type="hidden" name="id" value="${quiz.id}">
            <div class="mb-3">
              <label class="form-label">Name</label>
              <input type="text" class="form-control" name="name" value="${quiz.name}" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Subject</label>
              <input type="text" class="form-control" name="subject" value="${quiz.subject.name}" readonly>
              <input type="hidden" name="subjectId" value="${quiz.subject.id}">
            </div>

            <div class="mb-3">
              <label class="form-label">Level</label>
              <select class="form-control" name="level" required>
                <option value="Easy" ${quiz.level == 'Easy' ? 'selected' : ''}>Easy</option>
                <option value="Medium" ${quiz.level == 'Medium' ? 'selected' : ''}>Medium</option>
                <option value="Hard" ${quiz.level == 'Hard' ? 'selected' : ''}>Hard</option>
              </select>
            </div>
            <div class="mb-3">
              <label class="form-label">Format</label>
              <input type="text" class="form-control" name="format" value="${quiz.format}" disabled>
            </div>


            <div class="mb-3">
              <label class="form-label"># Questions</label>
              <input type="number" class="form-control" name="numberOfQuestions" value="${quiz.quizSetting.numberOfQuestions}" min="1" disabled>
            </div>

            <div class="mb-3">
              <label class="form-label">Duration (minutes)</label>
              <input type="number" class="form-control" name="duration" value="${(quiz.duration / 60).intValue()}" min="1" required>
            </div>

            <div class="mb-3">
              <label class="form-label">Pass Rate (%)</label>
              <input type="number" class="form-control" name="passRate" value="${quiz.passRate}" min="0" max="100" required>
            </div>

            <div class="mb-3">
              <label class="form-label">Quiz Type</label>
              <select class="form-control" name="testTypeId" required>
                <option value="2" ${quiz.testType.id == 2 ? 'selected' : ''}>LessonQuiz</option>
                <option value="1" ${quiz.testType.id == 1 ? 'selected' : ''}>Simulation</option>
              </select>
            </div>

            <div class="mt-3">
              <button type="submit" class="btn btn-primary">Save Changes</button>
              <a href="quizzeslist" class="btn btn-secondary">Cancel</a>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>

  <!-- Setting Tab -->
  <div id="Setting" class="tabcontent">
    <div class="row">
      <div class="col-md-10 offset-md-1">
        <div class="tile">
          <div class="tile-body ${hasAttempt ? 'disabled-overlay' : ''}">

            <c:if test="${hasAttempt}">
              <div class="alert alert-warning" role="alert">
                <i class="bi bi-exclamation-triangle"></i>
                This quiz has already been attempted and cannot be edited.
              </div>
            </c:if>
            <form action="quiz-setting" method="post" id="quizSettingForm">
              <input type="hidden" name="action" value="updateSetting">
              <input type="hidden" name="id" value="${quiz.id}">
              <input type="hidden" name="subjectId" value="${quiz.subject.id}">

              <div class="mb-4">
                <label class="form-label"><strong>Total Questions:</strong></label>
                <input
                        type="number"
                        class="form-control"
                        name="numberOfQuestions"
                        value="${quiz.quizSetting.numberOfQuestions}"
                        min="1"
                        required>
              </div>

              <div class="mb-4">
                <label class="form-label"><strong>Question Type:</strong></label>
                <div style="display: flex; gap: 20px; margin-top: 10px;">
                  <div class="form-check">
                    <input class="form-check-input" type="radio" name="questionType" id="lessonRadio" >
                    <label class="form-check-label" for="lessonRadio">By Lesson</label>
                  </div>
                  <div class="form-check">
                    <input class="form-check-input" type="radio" name="questionType" id="dimensionRadio">
                    <label class="form-check-label" for="dimensionRadio">By Dimension</label>
                  </div>
                </div>
              </div>

              <input id="questionType" type="hidden" name="type" />
              <div class="mb-4">
                <label class="form-label"><strong>Question Groups:</strong></label>
                <div id="questionGroupsContainer">
                  <div class="mb-2 row">
                    <div class="col-8">
                      <select class="form-control" name="questionGroups">
                        <option value="" disabled selected>Please select question type first</option>
                      </select>
                    </div>
                    <div class="col-2">
                      <input class="form-control" type="number" name="questionCounts" placeholder="#question" min="1" required>
                    </div>
                    <div class="col-2 d-grid">
                      <button class="btn btn-outline-success" type="button" onclick="addQuestionGroup()">Add</button>
                    </div>
                  </div>
                </div>
              </div>

              <div class="btn-group-container">
                <button type="submit" class="btn btn-primary" id="saveSettingsBtn">Save Settings</button>
                <a href="quizzeslist" class="btn btn-secondary">Back</a>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  </div>
</main>

<script>
  let selectQuestionType = ""; // lesson - dimension
  const dimensionRadio = document.getElementById("dimensionRadio");
  const lessonRadio = document.getElementById("lessonRadio");

  // Initialize dimensions array
  const allDimensions = [];
  <c:forEach var="dimension" items="${requestScope.dimensions}">
  allDimensions.push({
    id: ${dimension.getId()},
    name: "${dimension.getName()}",
    subjectId: ${dimension.getSubjectId()}
  });
  </c:forEach>

  // Initialize lessons array
  const allLessons = [];
  <c:forEach var="lesson" items="${requestScope.lessons}">
  allLessons.push({
    id: ${lesson.id},
    name: "${lesson.name}",
    subjectId: ${lesson.subjectId}
  });
  </c:forEach>

  // Initialize existing question groups
  const existingLessonGroups = [];
  <c:forEach var="group" items="${requestScope.listLessonQuestion}">
  existingLessonGroups.push({
    id: ${group.subjectLessonId},
    totalQuestions: ${group.numberQuestion}
  });
  </c:forEach>

  const existingDimensionGroups = [];
  <c:forEach var="group" items="${requestScope.listDimensionQuestion}">
  existingDimensionGroups.push({
    id: ${group.subjectDimensionId},
    totalQuestions: ${group.numberQuestion}
  });
  </c:forEach>

  // Set current quiz type
  const currentQuizType = "${requestScope.currentQuizType}";

  // Event listeners for radio buttons
  dimensionRadio.addEventListener("change", () => {
    selectQuestionType = "dimension";
    document.getElementById("questionType").value = "dimension";
    clearAndRebuildGroups();
    updateAllSelects();
  });

  lessonRadio.addEventListener("change", () => {
    selectQuestionType = "lesson";
    document.getElementById("questionType").value = "lesson";
    clearAndRebuildGroups();
    updateAllSelects();
  });

  // Function to clear and rebuild question groups
  function clearAndRebuildGroups() {
    const container = document.getElementById('questionGroupsContainer');

    // Clear all existing rows
    container.innerHTML = '';

    // Get the appropriate existing groups
    const existingGroups = selectQuestionType === 'lesson' ? existingLessonGroups : existingDimensionGroups;

    if (existingGroups.length > 0) {
      // Add existing groups
      existingGroups.forEach((group, index) => {
        addQuestionGroupWithData(group.id, group.totalQuestions, index === existingGroups.length - 1);
      });
    } else {
      // Add default empty row
      addDefaultQuestionGroup();
    }
  }

  // Function to add question group with existing data
  function addQuestionGroupWithData(selectedId, questionCount, isLast) {
    const container = document.getElementById('questionGroupsContainer');

    // Create new row
    const row = document.createElement('div');
    row.className = 'mb-2 row';

    // Select column
    const colSelect = document.createElement('div');
    colSelect.className = 'col-8';
    const select = document.createElement('select');
    select.className = 'form-control';
    select.name = 'questionGroups';
    select.required = true;

    // Update options for select
    updateSelectOptions(select);

    // Set selected value
    select.value = selectedId;

    colSelect.appendChild(select);

    // Input column
    const colInput = document.createElement('div');
    colInput.className = 'col-2';
    const input = document.createElement('input');
    input.type = 'number';
    input.className = 'form-control';
    input.name = 'questionCounts';
    input.placeholder = '#question';
    input.min = '1';
    input.value = questionCount;
    input.required = true;
    colInput.appendChild(input);

    // Button column
    const colBtn = document.createElement('div');
    colBtn.className = 'col-2 d-grid';
    const btn = document.createElement('button');
    btn.type = 'button';

    if (isLast) {
      btn.className = 'btn btn-outline-success';
      btn.textContent = 'Add';
      btn.onclick = addQuestionGroup;
    } else {
      btn.className = 'btn btn-outline-danger';
      btn.textContent = 'Remove';
      btn.onclick = function() {
        container.removeChild(row);
        updateRadioDisabledState();
      };
    }

    colBtn.appendChild(btn);

    // Append all to row
    row.appendChild(colSelect);
    row.appendChild(colInput);
    row.appendChild(colBtn);

    // Add to container
    container.appendChild(row);
  }

  // Function to add default empty question group
  function addDefaultQuestionGroup() {
    const container = document.getElementById('questionGroupsContainer');

    const row = document.createElement('div');
    row.className = 'mb-2 row';

    // Select column
    const colSelect = document.createElement('div');
    colSelect.className = 'col-8';
    const select = document.createElement('select');
    select.className = 'form-control';
    select.name = 'questionGroups';

    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.textContent = 'Please select question type first';
    defaultOption.disabled = true;
    defaultOption.selected = true;
    select.appendChild(defaultOption);

    colSelect.appendChild(select);

    // Input column
    const colInput = document.createElement('div');
    colInput.className = 'col-2';
    const input = document.createElement('input');
    input.type = 'number';
    input.className = 'form-control';
    input.name = 'questionCounts';
    input.placeholder = '#question';
    input.min = '1';
    input.required = true;
    colInput.appendChild(input);

    // Button column
    const colBtn = document.createElement('div');
    colBtn.className = 'col-2 d-grid';
    const addBtn = document.createElement('button');
    addBtn.className = 'btn btn-outline-success';
    addBtn.type = 'button';
    addBtn.textContent = 'Add';
    addBtn.onclick = addQuestionGroup;
    colBtn.appendChild(addBtn);

    // Append all to row
    row.appendChild(colSelect);
    row.appendChild(colInput);
    row.appendChild(colBtn);

    // Add to container
    container.appendChild(row);
  }

  // Function to update all selects in container
  function updateAllSelects() {
    const selects = document.querySelectorAll("#questionGroupsContainer select[name='questionGroups']");
    selects.forEach(select => {
      const currentValue = select.value;
      updateSelectOptions(select);
      if (currentValue) {
        select.value = currentValue;
      }
    });
  }

  // Function to update options for a specific select
  function updateSelectOptions(selectElement) {
    // Clear all current options
    selectElement.innerHTML = '';

    // Add default option
    const defaultOption = document.createElement('option');
    defaultOption.value = '';
    defaultOption.textContent = selectQuestionType === 'lesson' ? 'Select Lesson' : 'Select Dimension';
    defaultOption.disabled = true;
    defaultOption.selected = true;
    selectElement.appendChild(defaultOption);

    // Add options based on selected type
    const dataSource = selectQuestionType === 'lesson' ? allLessons : allDimensions;

    dataSource.forEach(item => {
      const option = document.createElement('option');
      option.value = item.id;
      option.textContent = item.name;
      selectElement.appendChild(option);
    });
  }

  // Function to check and update disabled state of radio buttons
  function updateRadioDisabledState() {
    const elementRows = document.querySelectorAll("#questionGroupsContainer .row");

    if (elementRows.length === 1) {
      dimensionRadio.disabled = false;
      lessonRadio.disabled = false;
    } else {
      dimensionRadio.disabled = true;
      lessonRadio.disabled = true;
    }
  }

  // Function to add new question group
  function addQuestionGroup() {
    // Check if question type is selected
    if (!selectQuestionType) {
      alert('Please select question type first (By Lesson or By Dimension)');
      return;
    }

    const container = document.getElementById('questionGroupsContainer');

    // Update last row's button to Remove
    const lastRow = container.lastElementChild;
    if (lastRow) {
      const lastBtn = lastRow.querySelector('button');
      lastBtn.textContent = 'Remove';
      lastBtn.className = 'btn btn-outline-danger';
      lastBtn.onclick = function () {
        container.removeChild(lastRow);
        updateRadioDisabledState();
      };
    }

    // Create new row
    const row = document.createElement('div');
    row.className = 'mb-2 row';

    // Select column
    const colSelect = document.createElement('div');
    colSelect.className = 'col-8';
    const select = document.createElement('select');
    select.className = 'form-control';
    select.name = 'questionGroups';
    select.required = true;

    // Update options for new select
    updateSelectOptions(select);

    colSelect.appendChild(select);

    // Input column
    const colInput = document.createElement('div');
    colInput.className = 'col-2';
    const input = document.createElement('input');
    input.type = 'number';
    input.className = 'form-control';
    input.name = 'questionCounts';
    input.placeholder = '#question';
    input.min = '1';
    input.required = true;
    colInput.appendChild(input);

    // Button column
    const colBtn = document.createElement('div');
    colBtn.className = 'col-2 d-grid';
    const addBtn = document.createElement('button');
    addBtn.className = 'btn btn-outline-success';
    addBtn.type = 'button';
    addBtn.textContent = 'Add';
    addBtn.onclick = addQuestionGroup;
    colBtn.appendChild(addBtn);

    // Append all to row
    row.appendChild(colSelect);
    row.appendChild(colInput);
    row.appendChild(colBtn);

    // Add to container
    container.appendChild(row);

    updateRadioDisabledState();
  }

  // Initialize on page load
  document.addEventListener('DOMContentLoaded', function() {
    // Set current quiz type if exists
    if (currentQuizType) {
      selectQuestionType = currentQuizType;
      document.getElementById("questionType").value = currentQuizType;

      if (currentQuizType === 'lesson') {
        lessonRadio.checked = true;
      } else if (currentQuizType === 'dimension') {
        dimensionRadio.checked = true;
      }

      clearAndRebuildGroups();
    } else {
      addDefaultQuestionGroup();
    }

    updateRadioDisabledState();
  });
</script>

<%@include file="common/jsload.jsp" %>
</body>
</html>