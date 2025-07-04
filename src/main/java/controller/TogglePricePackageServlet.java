package controller;

import java.io.IOException;
import java.io.PrintWriter;

import dao.PricePackageDAO;
import dao.SettingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * @author Dell
 */
@WebServlet(name = "TooglePricePackageServlet", urlPatterns = {"/toggle_price_package_status"})
public class TogglePricePackageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));

            PricePackageDAO pDAO = new PricePackageDAO();
            pDAO.updateStatus(id, status);

            int subjectID = pDAO.getSubjectId(id);
            // Chuyển hướng lại danh sách
            response.sendRedirect("get_price_package?subject_id=" + subjectID);
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
    }
}
