package io.conduktor.demos.projectmanagement.rest;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;

@Path("/comments")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class CommentResource {

    @POST
    public Response createComment() {
        return Response.status(Response.Status.CREATED)
                .entity("{\"message\": \"Comment created\"}").build();
    }

    @DELETE
    @Path("/{id}")
    public Response deleteComment(@PathParam("id") Long id) {
        return Response.ok("{\"message\": \"Comment deleted\"}").build();
    }
}