MIL_3_Tfile_Hdr_ 1871 175A modeler 9 61E03AB6 61E04243 9 DTU-5CG8190KT2 larst 0 0 none none 0 0 none 972E51A1 1181 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                             ??g?      D   H   L      ?  ?  ?  ?  i  u  y  }  ?  ?           	   begsim intrpt         
   ????   
   doc file            	nd_module      endsim intrpt             ????      failure intrpts            disabled      intrpt interval         ԲI?%??}????      priority              ????      recovery intrpts            disabled      subqueue                     count    ???   
   ????   
      list   	???   
          
      super priority             ????             int	\lppackets;       int	\hppackets;       Stathandle	\stat_lppackets;       Stathandle	\stat_hppackets;       Stathandle	\stat_packets;       Stathandle	\stat_lpdelay;       Stathandle	\stat_hpdelay;       Stathandle	\stat_glpdelay;       Stathandle	\stat_ghpdelay;              ;#define PowerUp     (op_intrpt_type() == OPC_INTRPT_BEGSIM)   9#define RcvPacket   (op_intrpt_type() == OPC_INTRPT_STRM)                                                  Z   ?          
   Init   
       J      lppackets = 0;   hppackets = 0;       cstat_lppackets = op_stat_reg("Low priority packets received", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   dstat_hppackets = op_stat_reg("High priority packets received", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   Tstat_packets = op_stat_reg("Packets received", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       ]stat_lpdelay = op_stat_reg("Low priority packet delay", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   ^stat_hpdelay = op_stat_reg("High priority packet delay", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       fstat_glpdelay = op_stat_reg("Global low priority packet delay", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);   gstat_ghpdelay = op_stat_reg("Global high priority packet delay", OPC_STAT_INDEX_NONE, OPC_STAT_GLOBAL);       )op_stat_write(stat_lppackets, lppackets);   )op_stat_write(stat_hppackets, hppackets);   3op_stat_write(stat_packets, lppackets + hppackets);   J                     
   ????   
          pr_state           ?          
   Idle   
                     J      Packet * pkptr;   	int prio;       op_prg_odb_bkpt("SINK");       pkptr = op_pk_get(0);   .op_pk_nfd_get_int32(pkptr, "Priority", &prio);   if (prio == 0)   	{   	lppackets++;   *	op_stat_write(stat_lppackets, lppackets);   	   J	op_stat_write(stat_lpdelay, op_sim_time() - op_pk_stamp_time_get(pkptr));   K	op_stat_write(stat_glpdelay, op_sim_time() - op_pk_stamp_time_get(pkptr));   	}   else   	{   	hppackets++;   *	op_stat_write(stat_hppackets, hppackets);       J	op_stat_write(stat_hpdelay, op_sim_time() - op_pk_stamp_time_get(pkptr));   K	op_stat_write(stat_ghpdelay, op_sim_time() - op_pk_stamp_time_get(pkptr));   	}   3op_stat_write(stat_packets, lppackets + hppackets);   J           ????             pr_state                        ?   ?      q   ?   ?   ?          
   tr_0   
       
   PowerUp   
       ????          
    ????   
          ????                       pr_transition              a   j        ?  [   q     ?  ?   ?  d   ?     ?          
   tr_1   
       
   	RcvPacket   
       ????          
    ????   
          ????                       pr_transition                   Low priority packets received        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   High priority packets received        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   Packets received        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   Low priority packet delay        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   High priority packet delay        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}       Global low priority packet delay        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   !Global high priority packet delay        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}                        