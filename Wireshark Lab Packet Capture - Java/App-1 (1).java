/* Example skeleton program for CS352 Wireshark 1 assignment  * * Reads a file call input.pcap and prints the first 5  * packets  * * pcap4j takes an PacketListener object as input and runs * a method on every packet.  * * See the PacketListener class and its gotPacket method below.  * * (c) 2021, R. P. Martin, released under the GPL version 2 *   */
package com.github.username;
import java.io.IOException;
import java.net.Inet4Address;
import com.sun.jna.Platform;
import org.pcap4j.core.NotOpenException;
import org.pcap4j.core.PacketListener;
import org.pcap4j.core.PcapDumper;
import org.pcap4j.core.PcapHandle;
import org.pcap4j.core.PcapNativeException;
import org.pcap4j.core.PcapNetworkInterface;
import org.pcap4j.core.PcapStat;
import org.pcap4j.core.BpfProgram.BpfCompileMode;
import org.pcap4j.core.PcapNetworkInterface.PromiscuousMode;
import org.pcap4j.core.Pcaps;
import org.pcap4j.packet.Packet;
import org.pcap4j.util.NifSelector;
import org.pcap4j.packet.IpV4Packet;
import org.pcap4j.packet.TcpPacket;
import org.pcap4j.packet.UdpPacket;
import java.util.Scanner;
import org.pcap4j.packet.namednumber.TcpPort;
import org.pcap4j.packet.IcmpV4CommonPacket;
class TcpFlow {
    String srcAddr;
    String destAddr;
    String srcPort;
    String destPort;
    int comPackets = 0;
    int incomPackets;
    boolean isFlow = false;
    double totalData;
    boolean openFlow = false;
    boolean flowSyn = false;
    boolean flowFin = false;
    long timeStart;
    long timeEnd;
    double inTotalData;
}
class additionalFlow {
    int numPackets;
    int totalData2 = 0;
}


public class App {
    static TcpFlow[] myTcpFlow = new TcpFlow[4];
    static int numPackets = 0;
    static additionalFlow[] myAddFlow = new additionalFlow[3];


    public static boolean isFlowEqual(TcpFlow tempTcpFlow, TcpFlow tempTcpFlow2) {
        if (!tempTcpFlow.srcAddr.equals(tempTcpFlow2.srcAddr)) {
            return false;
        } else if (!tempTcpFlow.destAddr.equals(tempTcpFlow2.destAddr)) {
            return false;
        } else if (!tempTcpFlow.srcPort.equals(tempTcpFlow2.srcPort)) {
            return false;
        } else if (!tempTcpFlow.destPort.equals(tempTcpFlow2.destPort)) {
            return false;
        }
        return true;
    }

    private static void grow() {
        if (myTcpFlow.length % 4 == 0 && myTcpFlow.length != 0) {
            TcpFlow[] tempFlow = new TcpFlow[myTcpFlow.length + 4];
            for (int x = 0; x < myTcpFlow.length; x++) {
                tempFlow[x] = myTcpFlow[x];
            }
            myTcpFlow = tempFlow;
        }
    }

    public static int find(TcpFlow tempTcpFlow) {
        for (int index = 0; index < myTcpFlow.length; index++) {
            if (myTcpFlow[index] == null) {
                continue;
            }
            if (isFlowEqual(tempTcpFlow, myTcpFlow[index])) {
                return index;
            }
        }
        return -1;
    }

    public static void add(TcpFlow tempTcpFlow) {
        if (tempTcpFlow == null) {
            return;
        }
        for (int index = 0; index < myTcpFlow.length; index++) {
            if (myTcpFlow[index] == null) {
                continue;
            }
            if (isFlowEqual(tempTcpFlow, myTcpFlow[index])) {
                if (myTcpFlow[index].openFlow == true) {
                    myTcpFlow[index].totalData += tempTcpFlow.totalData;
                    if (tempTcpFlow.flowFin == true) {
                        myTcpFlow[index].timeEnd = tempTcpFlow.timeEnd;
                        myTcpFlow[index].comPackets++;
                        myTcpFlow[index].openFlow = false;
                        return;
                    }
                    myTcpFlow[index].comPackets++;
                    return;
                }
                if (myTcpFlow[index].openFlow == false) {
                    myTcpFlow[index].inTotalData += tempTcpFlow.totalData;
                    if (tempTcpFlow.flowSyn == true) {
                        myTcpFlow[index].timeStart = tempTcpFlow.timeStart;
                        myTcpFlow[index].comPackets++;
                        myTcpFlow[index].openFlow = true;
                        return;
                    }
                    myTcpFlow[index].incomPackets++;
                    return;
                }
                return;
            }
        }

        grow();

        for (int index = 0; index < myTcpFlow.length; index++) {
            if (myTcpFlow[index] == null) {
                myTcpFlow[index] = tempTcpFlow;
                if (tempTcpFlow.openFlow == true) {
                    myTcpFlow[index].comPackets++;
                } else {
                    myTcpFlow[index].incomPackets++;
                }
                return;
            }
        }
        return;
    }

    public static void print() {
        System.out.println("TCP Summary Table");
        for (int i = 0; i < myTcpFlow.length; i++) {
            if (myTcpFlow[i] != null) {
                if (myTcpFlow[i].isFlow == true && myTcpFlow[i].openFlow != true) {

                    long timeTotal = myTcpFlow[i].timeEnd - myTcpFlow[i].timeStart;
                    double msToS = 1000000;
                    double bytesToMega = 125000;
                    double totalBytes = myTcpFlow[i].totalData;
                    double secondsConversion = (((double) timeTotal) / msToS);
                    double megaBytestotal = (((double) totalBytes) / bytesToMega);
                    double mbps = megaBytestotal / secondsConversion;
                    System.out.println(myTcpFlow[i].srcAddr.substring(1) + ", " + myTcpFlow[i].srcPort + ", " + myTcpFlow[i].destAddr.substring(1) + ", " + myTcpFlow[i].destPort + ", " + myTcpFlow[i].comPackets + ", " + myTcpFlow[i].incomPackets + ", " + (myTcpFlow[i].totalData + myTcpFlow[i].inTotalData) + ", " + mbps);
                } else if (myTcpFlow[i].openFlow == true) {
                    System.out.println(myTcpFlow[i].srcAddr.substring(1) + ", " + myTcpFlow[i].srcPort + ", " + myTcpFlow[i].destAddr.substring(1) + ", " + myTcpFlow[i].destPort + ", " + myTcpFlow[i].incomPackets + ", " + myTcpFlow[i].comPackets);
                } else {
                    System.out.println(myTcpFlow[i].srcAddr.substring(1) + ", " + myTcpFlow[i].srcPort + ", " + myTcpFlow[i].destAddr.substring(1) + ", " + myTcpFlow[i].destPort + ", " + myTcpFlow[i].comPackets + ", " + myTcpFlow[i].incomPackets);
                }
            }
        }
        System.out.println(" ");
        System.out.println("Additional Protocols Summary Table");
        System.out.println("UDP, " + myAddFlow[0].numPackets + ", " + myAddFlow[0].totalData2);
        System.out.println("ICMP, " + myAddFlow[1].numPackets + ", " + myAddFlow[1].totalData2);
        System.out.println("Other, " + myAddFlow[2].numPackets + ", " + myAddFlow[2].totalData2);

    }



    public static void main(String[] args) {
        System.out.println("Got here!");
        final PcapHandle handle;
        try {

            if (args.length > 0) {
                System.out.println(args[0]);
                handle = Pcaps.openOffline(args[0]);
            } else {
                handle = Pcaps.openOffline("input.pcap");
            }

        } catch (Exception e) {
            System.out.println("opening pcap file failed!");
            e.printStackTrace();
            return;
        }

        additionalFlow tempAddFlow = new additionalFlow();
        additionalFlow tempAddFlow2 = new additionalFlow();
        additionalFlow tempAddFlow3 = new additionalFlow();
        myAddFlow[0] = tempAddFlow;
        myAddFlow[1] = tempAddFlow2;
        myAddFlow[2] = tempAddFlow3;
        PacketListener listener = new PacketListener() {

            public void gotPacket(Packet packet) {




                if (packet.contains(TcpPacket.class)) {

                    TcpFlow tempTcpFlow = new TcpFlow();
                    tempTcpFlow.srcAddr = packet.get(IpV4Packet.class).getHeader().getSrcAddr().toString();
                    tempTcpFlow.destAddr = packet.get(IpV4Packet.class).getHeader().getDstAddr().toString();
                    tempTcpFlow.srcPort = packet.get(TcpPacket.class).getHeader().getSrcPort().valueAsString();
                    tempTcpFlow.destPort = packet.get(TcpPacket.class).getHeader().getDstPort().valueAsString();
                    tempTcpFlow.totalData += packet.getPayload().length() + packet.getHeader().length();
                    numPackets++;
                    boolean syn = packet.get(TcpPacket.class).getHeader().getSyn();
                    boolean fin = packet.get(TcpPacket.class).getHeader().getFin();
                    tempTcpFlow.flowSyn = syn;
                    tempTcpFlow.flowFin = fin;
                    if (syn == true) {
                        tempTcpFlow.timeStart = handle.getTimestamp().getTime();
                        tempTcpFlow.isFlow = true;
                        tempTcpFlow.openFlow = true;
                    }
                    if (fin == true) {
                        tempTcpFlow.timeEnd = handle.getTimestamp().getTime();
                        tempTcpFlow.openFlow = false;
                    }
                    add(tempTcpFlow);

                } else if (packet.contains(IcmpV4CommonPacket.class)) {
                    myAddFlow[1].numPackets++;
                    myAddFlow[1].totalData2 += packet.getPayload().length() + packet.getHeader().length();
                } else if (packet.contains(UdpPacket.class)) {
                    myAddFlow[0].numPackets++;
                    myAddFlow[0].totalData2 += packet.getPayload().length() + packet.getHeader().length();
                } else {

                    myAddFlow[2].numPackets++;
                    myAddFlow[2].totalData2 += packet.getRawData().length;
                }


            }
        };

        try {

            handle.loop(-1, listener);

        } catch (Exception e) {
            System.out.println("Error Processing pcap file!");
            e.printStackTrace();
            return;
        }

        print();



        handle.close();
    }
}
