MIL_3_Tfile_Hdr_ 1871 175A modeler 9 61E027B6 61E03EBE 1B DTU-5CG8190KT2 larst 0 0 none none 0 0 none 36B5FFE4 225B 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                            ??g?      D   ?   ?  ?  ?  ?  ~  ?   ?   C   O   S   W  t  ?      Timeout value   ???????   ????       ??      ????              ????              ????           ?Z                 	   begsim intrpt         
   ????   
   doc file            	nd_module      endsim intrpt             ????      failure intrpts            disabled      intrpt interval         ԲI?%??}????      priority              ????      recovery intrpts            disabled      subqueue                     count    ???   
   ????   
      list   	???   
          
      super priority             ????             int	\NextExpected;       int	\LastTransmitted;       Packet *	\PKLast;       Evhandle	\hTimer;       double	\timeoutvalue;       int	\packet_retx;       int	\total_retx;       Stathandle	\stat_pk_retx;       Stathandle	\stat_total_retx;           	   #define STRM_FROM_RX   1   #define STRM_TO_TX     0   #define STRM_FROM_SRC  0   #define STRM_TO_SINK   1       =#define PowerUp       (op_intrpt_type() == OPC_INTRPT_BEGSIM)   ;#define Timeout       (op_intrpt_type() == OPC_INTRPT_SELF)   d#define PacketFromSrc ((op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm() == STRM_FROM_SRC))   c#define PacketFromRX  ((op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm() == STRM_FROM_RX))                                                  Z            
   Init   
       J      Fop_ima_obj_attr_get_dbl(op_id_self(), "Timeout value", &timeoutvalue);       Ystat_pk_retx = op_stat_reg("PacketRetransmissions", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   [stat_total_retx = op_stat_reg("TotalRetransmissions", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       packet_retx = 0;   total_retx = 0;   )op_stat_write(stat_pk_retx, packet_retx);   +op_stat_write(stat_total_retx, total_retx);       NextExpected = 0;   LastTransmitted = 1;   J                     
   ????   
          pr_state                    
   Idle   
                                       ????             pr_state        ?            
   WaitACK   
                                   
    ????   
          pr_state          ?          
   	RXpacket1   
       
      Packet * pkptr;   Packet * payload;   int seq;        pkptr = op_pk_get(STRM_FROM_RX);       %if (op_pk_total_size_get(pkptr) == 1)   	{   '	// This is an ACK packet - ignore this   	op_pk_destroy(pkptr);   	}   else   	{   	// This is a p2p packet   4	op_pk_nfd_get_int32(pkptr, "SequenceNumber", &seq);   	if (seq == NextExpected)   		{   ,		op_pk_nfd_get(pkptr, "Payload", &payload);   $		op_pk_send(payload, STRM_TO_SINK);   "		NextExpected = 1 - NextExpected;   		}   	op_pk_destroy(pkptr);   	   +	pkptr = op_pk_create_fmt("p2p_ackpacket");   7	op_pk_nfd_set_int32(pkptr, "AckNumber", NextExpected);   	op_pk_send(pkptr, STRM_TO_TX);   	}   
                     
   ????   
          pr_state        ?   ?          
   
SrcPacket1   
       
      ,PKLast = op_pk_create_fmt("p2p_datapacket");   &LastTransmitted = 1 - LastTransmitted;   ?op_pk_nfd_set_int32(PKLast, "SequenceNumber", LastTransmitted);   ?op_pk_nfd_set_pkt(PKLast, "Payload", op_pk_get(STRM_FROM_SRC));       +op_pk_send(op_pk_copy(PKLast), STRM_TO_TX);   BhTimer = op_intrpt_schedule_self(op_sim_time() + timeoutvalue, 0);   
                     
   ????   
          pr_state        ?   ?          
   
Retransmit   
       
      +op_pk_send(op_pk_copy(PKLast), STRM_TO_TX);   BhTimer = op_intrpt_schedule_self(op_sim_time() + timeoutvalue, 0);   packet_retx++;   
                     
   ????   
          pr_state        v            
   
SrcPacket2   
       
      Packet * usrpkt;   	int prio;       "usrpkt = op_pk_get(STRM_FROM_SRC);   )op_pk_nfd_get(usrpkt, "Priority", &prio);   /op_subq_pk_insert(prio, usrpkt, OPC_QPOS_TAIL);   
                     
   ????   
          pr_state        ?  ?          
   	RXpacket2   
       
   8   Packet * pkptr;   Packet * payload;   int seq, acknum;        pkptr = op_pk_get(STRM_FROM_RX);       %if (op_pk_total_size_get(pkptr) == 1)   	{   	// This is an ACK   ,	op_pk_nfd_get(pkptr, "AckNumber", &acknum);   #	if (acknum == 1 - LastTransmitted)   		{   -		// ACK acknowledges last transmitted packet   "		op_ev_cancel_if_pending(hTimer);   		op_pk_destroy(PKLast);   		PKLast = OPC_NIL;   		   		total_retx += packet_retx;   +		op_stat_write(stat_pk_retx, packet_retx);   -		op_stat_write(stat_total_retx, total_retx);   		packet_retx = 0;   		   P		if (op_subq_stat(0, OPC_QSTAT_PKSIZE) + op_subq_stat(1, OPC_QSTAT_PKSIZE) > 0)   			{   -			if (op_subq_stat(1, OPC_QSTAT_PKSIZE) > 0)   2				payload = op_subq_pk_remove(1, OPC_QPOS_HEAD);   			else   2				payload = op_subq_pk_remove(0, OPC_QPOS_HEAD);   			   /			PKLast = op_pk_create_fmt("p2p_datapacket");   )			LastTransmitted = 1 - LastTransmitted;   B			op_pk_nfd_set_int32(PKLast, "SequenceNumber", LastTransmitted);   1			op_pk_nfd_set_pkt(PKLast, "Payload", payload);   .			op_pk_send(op_pk_copy(PKLast), STRM_TO_TX);   E			hTimer = op_intrpt_schedule_self(op_sim_time() + timeoutvalue, 0);   			}   		}       	op_pk_destroy(pkptr);   	}   else   	{   	// This is a p2p packet   4	op_pk_nfd_get_int32(pkptr, "SequenceNumber", &seq);   	if (seq == NextExpected)   		{   ,		op_pk_nfd_get(pkptr, "Payload", &payload);   $		op_pk_send(payload, STRM_TO_SINK);   "		NextExpected = 1 - NextExpected;   		}   	op_pk_destroy(pkptr);   	   +	pkptr = op_pk_create_fmt("p2p_ackpacket");   7	op_pk_nfd_set_int32(pkptr, "AckNumber", NextExpected);   	op_pk_send(pkptr, STRM_TO_TX);   	}   
                     
   ????   
          pr_state                        ?        i     ?            
   tr_0   
       
   PowerUp   
       ????          
    ????   
          ????                       pr_transition              F  V         &  J    q          
   tr_1   
       
   PacketFromRX   
       ????          
    ????   
          ????                       pr_transition               ?  \      ?  q   ?  G               
   tr_2   
       ????          ????          
    ????   
          ????                       pr_transition              5   ?        ?  ?   ?          
   tr_3   
       
   PacketFromSrc   
       ????          
    ????   
          ????                       pr_transition              ?   ?     ?   ?  ?   ?          
   tr_4   
       ????          ????          
    ????   
          ????                       pr_transition              ?   ?     ?   ?  ?   ?  ?   ?          
   tr_5   
       
   Timeout   
       ????          
    ????   
          ????                       pr_transition                 ?        ?     ?     ?          
   tr_6   
       ????          ????          
    ????   
          ????                       pr_transition              J   ?         =   ?  p   ?          
   tr_7   
       
   PacketFromSrc   
       ????          
    ????   
          ????                       pr_transition              Z  &     s     @  ,  
            
   tr_8   
       ????          ????          
    ????   
          ????                       pr_transition      	        7  T           F    y          
   tr_9   
       
   PacketFromRX   
       ????          
    ????   
          ????                       pr_transition      
        ?  8     ?  t  ?  D  ?            
   tr_10   
       
   PKLast   
       ????          
    ????   
          ????                       pr_transition              ?  8     ?  }              
   tr_11   
       
   !PKLast   
       ????          
    ????   
          ????                       pr_transition                   PacketRetransmissions        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   TotalRetransmissions        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}                            