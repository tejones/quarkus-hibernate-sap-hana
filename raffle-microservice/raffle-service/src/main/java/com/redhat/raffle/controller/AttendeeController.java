package com.redhat.raffle.controller;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import com.redhat.raffle.bean.Attendee;
import com.redhat.raffle.repository.RaffleRepository;

@RestController
public class AttendeeController {
	
	public static String EMPTY_STRING = "";

	@Autowired
	private RaffleRepository raffleRepository;

	//Return all attendees sorted by updatedDate
	@GetMapping("/raffle/attendees")
	public List<Attendee> getAttendees() {
		AttendeeUpdatedTimeComparator attendeeComparator = new AttendeeUpdatedTimeComparator();
		List<Attendee> attendees = raffleRepository.findAll();
		Collections.sort(attendees, attendeeComparator);
		return attendees;
	}
	
	@GetMapping("/raffle/randomizedattendees")
	public List<Attendee> getRandomizedAttendees() {
		List<Attendee> attendees = raffleRepository.findAll();
		Collections.shuffle(attendees);
		return attendees;
	}

	@GetMapping("raffle/scanAttendee/{scannedValue}")
	public Attendee scanAttendee(@PathVariable String scannedValue) {
//		String originalScannedvalue = scannedValue;
//		String newScannedValue = scannedValue.replace("z_1", EMPTY_STRING);
//		newScannedValue = newScannedValue.replace("_", EMPTY_STRING);
		System.out.print("ScannedValue = " + scannedValue);
		String[] parsedScannedValue = scannedValue.split("\\^");
		String lastName = parsedScannedValue[2];
		String firstName = parsedScannedValue[1];
		String uid = parsedScannedValue[0];

		Attendee attendee = new Attendee();
		attendee.setId(uid);
		attendee.setFirstName(firstName);
		attendee.setLastName(lastName);
		attendee.setScannedValue(scannedValue);

		return raffleRepository.save(attendee);
	}

public class AttendeeUpdatedTimeComparator implements Comparator<Attendee> {
    @Override
    public int compare(Attendee firstAttendee, Attendee secondAttendee) {
       return (secondAttendee.getUpdatedAt().compareTo(firstAttendee.getUpdatedAt()));
    }
}
}