MIL_3_Tfile_Hdr_ 1871 175A modeler 9 61E03739 61E040F6 5 DTU-5CG8190KT2 larst 0 0 none none 0 0 none 9E9FB6B7 FF6 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                              ??g?      D  A  E      ?  ?  ?  ?  ?  ?  ?  ?  ?  ?      Packet rate   ???????   ????       ??      ????              ????              ????           ?Z             High priority fraction   ???????   ????       ??      ????              ????              ????           ?Z                 	   begsim intrpt         
   ????   
   doc file            	nd_module      endsim intrpt             ????      failure intrpts            disabled      intrpt interval         ԲI?%??}????      priority              ????      recovery intrpts            disabled      subqueue                     count    ???   
   ????   
      list   	???   
          
      super priority             ????             double	\packetrate;       double	\hpfraction;       int	\hppackets;       int	\lppackets;       Stathandle	\stat_hppackets;       Stathandle	\stat_lppackets;       Stathandle	\stat_packets;              /* EVENTS */    9#define PowerUp			(op_intrpt_type() == OPC_INTRPT_BEGSIM)   =#define IntervalTimeout (op_intrpt_type() == OPC_INTRPT_SELF)                                                  Z   Z          
   Init   
       
      // Read attributes   >op_ima_obj_attr_get(op_id_self(), "Packet rate", &packetrate);   Iop_ima_obj_attr_get(op_id_self(), "High priority fraction", &hpfraction);       dstat_lppackets = op_stat_reg("Low priority packets generated", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   estat_hppackets = op_stat_reg("High priority packets generated", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   Ustat_packets = op_stat_reg("Packets generated", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       lppackets = 0;   hppackets = 0;        // Write initial values to stats   )op_stat_write(stat_lppackets, lppackets);   )op_stat_write(stat_hppackets, hppackets);   3op_stat_write(stat_packets, lppackets + hppackets);       if (packetrate > 0.0)   Q	op_intrpt_schedule_self(op_sim_time() + op_dist_exponential(1.0/packetrate), 0);   
       
       
       
   ????   
          pr_state           Z          
   Idle   
       
       
       J      &// Generate a packet and restart timer       Packet * pkptr;   	int prio;       // Priority   3prio = (op_dist_uniform(1.0) < hpfraction ? 1 : 0);       *pkptr = op_pk_create_fmt("p2p_usrpacket");   -op_pk_nfd_set_int32(pkptr, "Priority", prio);   op_pk_send(pkptr, 0);       if (prio == 0)   	{   	lppackets++;   *	op_stat_write(stat_lppackets, lppackets);   	}   else   	{   	hppackets++;   *	op_stat_write(stat_hppackets, hppackets);   	}       3op_stat_write(stat_packets, lppackets + hppackets);       Pop_intrpt_schedule_self(op_sim_time() + op_dist_exponential(1.0/packetrate), 0);   J           ????             pr_state                     ?           I  *   :  B   .  N   4  Z   |     ^          
   tr_2   
       
   IntervalTimeout   
       
????   
       
    ????   
          ????                       pr_transition                ?   R      m   X   ?   X          
   tr_3   
       
   PowerUp   
       ????          
    ????   
          ????                       pr_transition                   Low priority packets generated        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   High priority packets generated        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   Packets generated        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}                            