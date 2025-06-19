package dto;

import entity.QuizSetting;
import entity.Subject;
import entity.TestType;

public class QuizDTO {

    private int id;
    private String name;
    private Subject subject;
    private String level;
    private QuizSetting quizSetting;
    private TestType testType;
    private int status;
    private int  duration;
    private int passRate;
    private String format;


    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Subject getSubject() {
        return subject;
    }

    public void setSubject(Subject subject) {
        this.subject = subject;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public TestType getTestType() {
        return testType;
    }

    public void setTestType(TestType testType) {
        this.testType = testType;
    }

    public QuizSetting getQuizSetting() {
        return quizSetting;
    }

    public void setQuizSetting(QuizSetting quizSetting) {
        this.quizSetting = quizSetting;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
    }

    public int getPassRate() {
        return passRate;
    }

    public void setPassRate(int passRate) {
        this.passRate = passRate;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }
}
