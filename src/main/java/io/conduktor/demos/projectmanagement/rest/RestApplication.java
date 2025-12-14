package io.conduktor.demos.projectmanagement.rest;

import jakarta.ws.rs.ApplicationPath;
import jakarta.ws.rs.core.Application;
import java.util.HashSet;
import java.util.Set;

@ApplicationPath("/")
public class RestApplication extends Application {

    @Override
    public Set<Class<?>> getClasses() {
        Set<Class<?>> classes = new HashSet<>();

        // Register all REST resource classes
        classes.add(ProjectResource.class);
        classes.add(TaskResource.class);
        classes.add(DashboardResource.class);
        classes.add(CommentResource.class);

        return classes;
    }
}
