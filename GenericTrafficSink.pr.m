MIL_3_Tfile_Hdr_ 1871 175A modeler 9 5F29550A 61DB5D09 10 DTU-5CG8190KT2 larst 0 0 none none 0 0 none 58635AC9 1477 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                            ??g?      D   H   L      ?  Z  ^  [  _  k  o  s  ?  ?           	   begsim intrpt         
   ????   
   doc file            	nd_module      endsim intrpt             ????      failure intrpts            disabled      intrpt interval         ԲI?%??}????      priority              ????      recovery intrpts            disabled      subqueue                     count    ???   
   ????   
      list   	???   
          
      super priority             ????              Stathandle	\PacketsReceivedStat;       Stathandle	\BitsReceivedStat;       Stathandle	\PacketSizeStat;       Stathandle	\BitRateStat;       Stathandle	\PacketDelayStat;       Stathandle	\PacketIntervalStat;       int	\PacketsReceived;       int	\BitsReceived;       int	\PacketSize;       double	\BitRate;       double	\PacketDelay;       double	\PacketInterval;       double	\PreviousPacket;              /* Events */   9#define PowerUp			(op_intrpt_type() == OPC_INTRPT_BEGSIM)   <#define PacketArrival 	(op_intrpt_type() == OPC_INTRPT_STRM)   ?#define PowerDown       (op_intrpt_type() == OPC_INTRPT_ENDSIM)                                                  Z   Z          
   Init   
                     J      // Register statistics   [PacketsReceivedStat = op_stat_reg("Packets Received", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   UBitsReceivedStat = op_stat_reg("Bits Received", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   QPacketSizeStat = op_stat_reg("Packet Size", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   JBitRateStat = op_stat_reg("BitRate", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   SPacketDelayStat = op_stat_reg("Packet Delay", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   XPacketIntervalStat = op_stat_reg("PacketInterval", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       // Initialize state variables   PacketsReceived = 0;   BitsReceived = 0;   PacketSize = 0;   BitRate = 0.0;   PacketDelay = 0.0;   PacketInterval = 0.0;   PreviousPacket = 0.0;   J       
   ????   
          pr_state         ?   Z          
   Idle   
                                       ????             pr_state        J   Z          
   PktRcvd   
       
      Packet* pkptr;       &// Receive packet from incoming stream   $pkptr = op_pk_get(op_intrpt_strm());       if (PacketsReceived > 0) {   C	op_stat_write(PacketIntervalStat, op_sim_time() - PreviousPacket);   }   PreviousPacket = op_sim_time();       PacketsReceived++;   ,BitsReceived += op_pk_total_size_get(pkptr);   BBitRate = (BitsReceived / op_sim_time());   // Avg bit rate so far   PPacketDelay = op_sim_time() - op_pk_stamp_time_get(pkptr);   // E2E packet delay       4op_stat_write(PacketsReceivedStat, PacketsReceived);   .op_stat_write(BitsReceivedStat, BitsReceived);   ;op_stat_write(PacketSizeStat, op_pk_total_size_get(pkptr));   $op_stat_write(BitRateStat, BitRate);   ,op_stat_write(PacketDelayStat, PacketDelay);       op_pk_destroy(pkptr);   
                     
   ????   
          pr_state         ?   ?          
   EndSim   
       
      =op_stat_write(BitRateStat, 1.0*BitsReceived / op_sim_time());   
                     
   ????   
          pr_state                        ?   R      m   [   ?   [          
   tr_0   
       
   PowerUp   
       ????          
    ????   
          ????                       pr_transition                 R      ?   [  3   [          
   tr_2   
       
   PacketArrival   
       ????          
    ????   
          ????                       pr_transition                 g     <   g   ?   g          
   tr_3   
       ????          ????          
    ????   
          ????                       pr_transition                 ?      ?   j   ?   ?   ?   ?          
   tr_7   
       
   	PowerDown   
       ????          
    ????   
          ????                       pr_transition               ?   ?      ?   ?   ?   ?   ?   g          
   tr_8   
       ????          ????          
    ????   
          ????                       pr_transition         	          Packets Received        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   Bits Received        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   Packet Size        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   Packet Delay        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   BitRate        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   PacketInterval        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}                            