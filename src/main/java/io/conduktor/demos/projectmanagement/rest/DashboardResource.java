package io.conduktor.demos.projectmanagement.rest;

import io.conduktor.demos.projectmanagement.service.DashboardService;
import io.conduktor.demos.projectmanagement.util.DatabaseUtil;
import jakarta.persistence.EntityManager;
import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import java.util.Map;

@Path("/dashboard")
@Produces(MediaType.APPLICATION_JSON)
public class DashboardResource {

    private DashboardService dashboardService;
    private EntityManager entityManager;

    public DashboardResource() {
        this.entityManager = DatabaseUtil.getEntityManager();
        this.dashboardService = new DashboardService(entityManager);
    }

    @GET
    public Response getDashboard(@QueryParam("userId") Long userId) {
        if (userId == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("{\"error\": \"User ID is required\"}").build();
        }

        try {
            Map<String, Object> stats = dashboardService.getDashboardStats(userId);
            return Response.ok(stats).build();
        } catch (Exception e) {
            return Response.status(Response.Status.INTERNAL_SERVER_ERROR)
                    .entity("{\"error\": \"Failed to fetch dashboard: " + e.getMessage() + "\"}").build();
        }
    }
}