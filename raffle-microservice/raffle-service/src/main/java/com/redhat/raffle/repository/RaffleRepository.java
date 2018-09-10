package com.redhat.raffle.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.redhat.raffle.bean.Attendee;

@Repository
public interface RaffleRepository extends JpaRepository<Attendee, String> {
	List<Attendee> findById(String uid);

	boolean existsById(String uid);
}