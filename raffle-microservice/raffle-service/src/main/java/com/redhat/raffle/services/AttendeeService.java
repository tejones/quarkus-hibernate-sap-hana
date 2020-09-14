package com.redhat.raffle.services;

import com.redhat.raffle.bean.Attendee;
import com.redhat.raffle.repository.RaffleRepository;
import javax.ws.rs.PathParam;

import javax.inject.Inject;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import java.util.List;

@Path("/raffle")
public class AttendeeService {

    @Inject
    private RaffleRepository raffleRepository;

    @GET
    @Path("/attendees")
    @Consumes(MediaType.APPLICATION_JSON)
    @Produces(MediaType.APPLICATION_JSON)
    public List<Attendee> getAttendees() {
        return raffleRepository.getAttendees();
    }

    @GET
    @Path("/randomizedattendees")
    @Produces(MediaType.APPLICATION_JSON)
    public List<Attendee> getRandomizedAttendees(String scannedValue) {
        return raffleRepository.getRandomizedAttendees();
    }

    @GET
    @Path("/scanAttendee/{scannedValue}")
//    @Consumes(MediaType.APPLICATION_JSON)
    @Produces("application/json")
    public Attendee scanAttendee(@PathParam("scannedValue") String scannedValue) {
        return raffleRepository.scanAttendee(scannedValue);
    }
}
