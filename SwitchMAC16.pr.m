MIL_3_Tfile_Hdr_ 1871 175A modeler 9 61E15147 61E151C3 2 DTU-5CG8190KT2 larst 0 0 none none 0 0 none 883D93A9 138B 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                             ??g?      D   ?   ?  ?  ?  ?  ?  ?  ?  s    ?  ?  ?  ?      Timeout   ???????   ????       @r?     ????              ????              ????           ?Z                 	   begsim intrpt         
   ????   
   doc file            	nd_module      endsim intrpt             ????      failure intrpts            disabled      intrpt interval         ԲI?%??}????      priority              ????      recovery intrpts            disabled      subqueue                     count    ???   
   ????   
      list   	???   
          
      super priority             ????             int	\ports[NUMBER_OF_PORTS];       "Evhandle	\timers[NUMBER_OF_PORTS];       double	\timeout;       #Stathandle	\stat_packets_forwarded;       %Stathandle	\stat_packets_broadcasted;       int	\packets_forwarded;       int	\packets_broadcasted;       Stathandle	\stat_ratio;              #define NUMBER_OF_PORTS    16       7#define PowerUp (op_intrpt_type() == OPC_INTRPT_BEGSIM)   5#define Timeout (op_intrpt_type() == OPC_INTRPT_SELF)   6#define PacketIn (op_intrpt_type() == OPC_INTRPT_STRM)                                                  ?   ?          
   init   
       J      int i;       7op_ima_obj_attr_get(op_id_self(), "Timeout", &timeout);       _stat_packets_forwarded = op_stat_reg("Packets forwarded", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   cstat_packets_broadcasted = op_stat_reg("Packets broadcasted", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   Gstat_ratio = op_stat_reg("Ratio", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       %for(i = 0 ; i < NUMBER_OF_PORTS; i++)   	ports[i] = -1;       J                     
   ????   
          pr_state        J   ?          
   Idle   
                                       ????             pr_state        J   Z          
   Timer   
       
      ports[op_intrpt_code()] = -1;   
                     
   ????   
          pr_state        J  J          
   Packet   
       J   '   int i;   	int port;   int src;   int dst;   Packet * pkptr;       port = op_intrpt_strm();   pkptr = op_pk_get(port);   ,op_pk_nfd_get_int32(pkptr, "SrcAddr", &src);   ,op_pk_nfd_get_int32(pkptr, "DstAddr", &dst);       // Address learning   &op_ev_cancel_if_pending(timers[port]);   Ftimers[port] = op_intrpt_schedule_self(op_sim_time() + timeout, port);   ports[port] = src;       // Forwarding   Bfor (i = 0, port = -1; (i < NUMBER_OF_PORTS) && (port == -1); i++)   #	port = (ports[i] == dst ? i : -1);       packets_forwarded++;   9op_stat_write(stat_packets_forwarded, packets_forwarded);       if (port > -1)   	{   	op_pk_send(pkptr, port);   	}   else   	{   	packets_broadcasted++;   >	op_stat_write(stat_packets_broadcasted, packets_broadcasted);       &	for (i = 0; i < NUMBER_OF_PORTS; i++)   #		op_pk_send(op_pk_copy(pkptr), i);       	op_pk_destroy(pkptr);   	}       Eop_stat_write(stat_ratio, 1.0*packets_broadcasted/packets_forwarded);   J                     
   ????   
          pr_state                       ?   ?      ?   ?  9   ?          
   tr_3   
       
   PowerUp   
       ????          
    ????   
          ????                       pr_transition                 ?     F   ?  1   ?  F   k          
   tr_5   
       
   Timeout   
       ????          
    ????   
          ????                       pr_transition                 
     R   n  a   ?  U   ?          
   tr_6   
       ????          ????          
    ????   
          ????                       pr_transition              }       [   ?  g  
  X  C          
   tr_7   
       
   PacketIn   
       ????          
    ????   
          ????                       pr_transition               ?   ?     @  7  4    =   ?          
   tr_8   
       ????          ????          
    ????   
          ????                       pr_transition         	          Packets forwarded        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   Packets broadcasted        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   Ratio        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}      forward        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   	broadcast        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}                        