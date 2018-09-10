package com.redhat.raffle.bean;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "attendee")
public class Attendee extends AuditModel {
   
	@Id
	@Column(columnDefinition = "id")
    private String id;

    @Column(columnDefinition = "first_name")
    private String firstName;

    @Column(columnDefinition = "last_name")
    private String lastName;
    
    @Column(columnDefinition = "scanned_value")
    private String scannedValue;
    
    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }
    
    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }
    
    public String getScannedValue() {
        return scannedValue;
    }

    public void setScannedValue(String scannedValue) {
        this.scannedValue = scannedValue;
    }
}