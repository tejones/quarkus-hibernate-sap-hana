package com.redhat.raffle.repository;

import com.redhat.raffle.bean.Attendee;
import io.quarkus.hibernate.orm.panache.PanacheRepository;

import javax.enterprise.context.ApplicationScoped;
import javax.transaction.Transactional;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

@ApplicationScoped
public class RaffleRepository implements PanacheRepository<Attendee> {
	private static String EMPTY_STRING = "";

	public List<Attendee> getAttendees() {
		List<Attendee> res =find("from Attendee").list();
		Collections.sort(res, new AttendeeUpdatedTimeComparator());
		return res;
	}

	public List<Attendee> getRandomizedAttendees() {
		List<Attendee> res =find("from Attendee").list();
		Collections.shuffle(res);
		return res;
	}

	@Transactional
	public Attendee scanAttendee(String scannedValue) {
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
		persist(attendee);
		return attendee;
    }

	public class AttendeeUpdatedTimeComparator implements Comparator<Attendee> {
		@Override
		public int compare(Attendee firstAttendee, Attendee secondAttendee) {
			return (secondAttendee.getUpdatedAt().compareTo(firstAttendee.getUpdatedAt()));
		}
	}
}
