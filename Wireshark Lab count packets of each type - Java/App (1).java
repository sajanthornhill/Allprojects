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

public class App {
    static int packetCount;
    static int udpCount;
    static int tcpCount;
    static long timeElasped;
    static long timeElasped2;
    static int totalBytes;

    public static void packetIncrement() {
        packetCount++;
    }
    public static void udpIncrement() {
        udpCount++;
    }
    public static void tcpIncrement() {
        tcpCount++;
    }
    public static void lastPacketTime(long packetTime) {
        timeElasped2 = packetTime;
    }

    public static void firstPacketTime(long packetTime) {
        timeElasped = packetTime;
    }

    public static int returnIncrement() {
        return packetCount;
    }

    public static void totalData(int bytes) {
        totalBytes += bytes;
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
        PacketListener listener = new PacketListener() {

            public void gotPacket(Packet packet) {


                if (returnIncrement() == 0) {
                    firstPacketTime(handle.getTimestamp().getTime());
                }
                packetIncrement();
                if (packet.contains(TcpPacket.class)) {
                    tcpIncrement();
                }
                if (packet.contains(UdpPacket.class)) {
                    udpIncrement();
                }

                lastPacketTime(handle.getTimestamp().getTime());
                totalData(packet.getPayload().length() + packet.getHeader().length());

            }
        };

        try {

            handle.loop(-1, listener);

        } catch (Exception e) {
            System.out.println("Error Processing pcap file!");
            e.printStackTrace();
            return;
        }
        System.out.println("  ");
        System.out.println("Total number of packets, " + packetCount);
        System.out.println("Total number of TCP packets, " + tcpCount);
        System.out.println("Total number of UDP packets, " + udpCount);
        double msToS = 1000;
        double bytesToMega = 125000;
        long timeTotal = (timeElasped2 - timeElasped);
        double secondsConversion = (((double) timeTotal) / msToS);
        double megaBytestotal = (((double) totalBytes) / bytesToMega);
        double mbps = megaBytestotal / secondsConversion;
        System.out.println("Total bandwidth of the packet trace in Mbps, " + mbps);
        handle.close();
    }
}
