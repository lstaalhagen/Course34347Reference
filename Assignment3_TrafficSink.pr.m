MIL_3_Tfile_Hdr_ 1871 175A modeler 9 5F3112BE 5F3253C5 B DTU-CZC8338FC1 s164146 0 0 none none 0 0 none 9AAC97E6 164E 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                           ��g�      D   H   L      �  �  �  o  6  B  F  J  �  �           	   begsim intrpt         
   ����   
   doc file            	nd_module      endsim intrpt         
   ����   
   failure intrpts            disabled      intrpt interval         ԲI�%��}����      priority              ����      recovery intrpts            disabled      subqueue                     count    ���   
   ����   
      list   	���   
          
      super priority             ����              Stathandle	\PacketsReceivedStat;       int	\PacketsReceived;       $Stathandle	\LowPriorityReceivedStat;       %Stathandle	\HighPriorityReceivedStat;       int	\LowPriorityReceived;       int	\HighPriorityReceived;       "Stathandle	\HighPriorityDelayStat;       !Stathandle	\LowPriorityDelayStat;       'Stathandle	\LowPriorityDelayGlobalStat;       (Stathandle	\HighPriorityDelayGlobalStat;              /* Events */   9#define PowerUp			(op_intrpt_type() == OPC_INTRPT_BEGSIM)   <#define PacketArrival 	(op_intrpt_type() == OPC_INTRPT_STRM)   #define HIGH_PRIORITY   1       ;#define PowerDown 		(op_intrpt_type() == OPC_INTRPT_ENDSIM)                                                  �   Z          
   Init   
                     
      ]PacketsReceivedStat = op_stat_reg("Packets Received", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);;    lLowPriorityReceivedStat = op_stat_reg("Low Priority Packets Received", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   ^LowPriorityDelayStat = op_stat_reg("Low Priority Delay", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   lLowPriorityDelayGlobalStat = op_stat_reg("Low Priority Delay Global", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   `HighPriorityDelayStat = op_stat_reg("High Priority Delay", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   nHighPriorityDelayGlobalStat = op_stat_reg("High Priority Delay Global", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   nHighPriorityReceivedStat = op_stat_reg("High Priority Packets Received", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);               LowPriorityReceived = 0;   HighPriorityReceived = 0;           PacketsReceived = 0;   
       
   ����   
          pr_state         �            
   Idle   
                                       ����             pr_state         Z  �          
   st_4   
       J      Packet* pkptr;   int priority;   double PacketDelay;           $pkptr = op_pk_get(op_intrpt_strm());       PacketsReceived++;   4op_stat_write(PacketsReceivedStat, PacketsReceived);       :PacketDelay = op_sim_time() - op_pk_stamp_time_get(pkptr);       /op_pk_nfd_access(pkptr, "priority", &priority);        if (priority == HIGH_PRIORITY) {   	HighPriorityReceived++;   ?	op_stat_write(HighPriorityReceivedStat, HighPriorityReceived);   9	op_stat_write(HighPriorityDelayGlobalStat, PacketDelay);   3	op_stat_write(HighPriorityDelayStat, PacketDelay);   	   } else {   	LowPriorityReceived++;   =	op_stat_write(LowPriorityReceivedStat, LowPriorityReceived);   8	op_stat_write(LowPriorityDelayGlobalStat, PacketDelay);   2	op_stat_write(LowPriorityDelayStat, PacketDelay);   }           op_pk_destroy(pkptr);   J                     
   ����   
          pr_state        J  J          
   Endsim   
       
      4op_stat_write(PacketsReceivedStat, PacketsReceived);   <op_stat_write(LowPriorityReceivedStat, LowPriorityReceived);   >op_stat_write(HighPriorityReceivedStat, HighPriorityReceived);       
                     
    ����   
          pr_state                        �   �      �   g   �   �          
   tr_0   
       
   PowerUp   
       ����          
    ����   
          ����                       pr_transition               w  J      �  "   X  q          
   tr_2   
       
   PacketArrival   
       ����          
    ����   
          ����                       pr_transition               �  �      c  �   �     �            
   tr_3   
       ����          ����          
    ����   
          ����                       pr_transition                 $      �    =  :          
   tr_4   
       
   	PowerDown   
       ����          
    ����   
          ����                       pr_transition              _  z     Q  ^  l  �  �    X  2          
   tr_7   
       ����          ����          
    ����   
          ����                       pr_transition                   Packets Received        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}   Low Priority Packets Received        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}   High Priority Packets Received        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}   Low Priority Delay        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}   High Priority Delay        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}      Low Priority Delay Global        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}   High Priority Delay Global        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}                        