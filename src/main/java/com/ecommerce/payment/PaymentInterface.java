package com.ecommerce.payment;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface PaymentInterface extends Remote {
    boolean validatePayment(String cardNumber, double amount) throws RemoteException;
}
