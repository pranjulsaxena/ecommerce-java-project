package com.ecommerce.payment;

import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.registry.Registry;
import java.rmi.server.UnicastRemoteObject;

public class PaymentServerImpl extends UnicastRemoteObject implements PaymentInterface {

    protected PaymentServerImpl() throws RemoteException {
        super();
    }

    @Override
    public boolean validatePayment(String cardNumber, double amount) throws RemoteException {
        // Mock validation: true if cardNumber is exactly 16 characters and amount > 0
        return cardNumber != null && cardNumber.length() == 16 && amount > 0;
    }

    public static void main(String[] args) {
        try {
            // Create an instance of the server implementation
            PaymentServerImpl server = new PaymentServerImpl();

            // Start the RMI registry on port 1099
            Registry registry = LocateRegistry.createRegistry(1099);

            // Bind the server instance to the name 'PaymentService'
            registry.rebind("PaymentService", server);

            System.out.println("PaymentService RMI Server is running on port 1099...");
        } catch (Exception e) {
            System.err.println("PaymentService exception:");
            e.printStackTrace();
        }
    }
}
