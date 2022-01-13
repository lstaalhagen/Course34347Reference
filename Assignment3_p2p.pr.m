MIL_3_Tfile_Hdr_ 1871 175A modeler 9 5F3129D2 5F33A7F8 23 DTU-CZC8338FC1 s164146 0 0 none none 0 0 none 509111B8 2FD6 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                          ��g�      D   �   �  �  �  6  ,�  ,�  -�  -�  -�  -�  -�  &  2      TimeoutValue   �������   ����       ?�      ����              ����              ����           �Z                 	   begsim intrpt         
   ����   
   doc file            	nd_module      endsim intrpt             ����      failure intrpts            disabled      intrpt interval         ԲI�%��}����      priority              ����      recovery intrpts            disabled      subqueue                     count    ���   
   ����   
      list   	���   
          
      super priority             ����             2/* Sequence number for packets sent (not ACKs). */   int	\SentN;       5/* Sequence number for packets received (not ACKs) */   
int	\RecN;       Evhandle	\Timer;       Packet *	\PreviousPacket;       double	\TimeoutValue;        Stathandle	\RetransmissionsStat;       int	\Retransmissions;       %Stathandle	\RetransmissionsTotalStat;       int	\RetransmissionsTotal;          	int ackN;   Packet* sendPkptr;   Packet* pkptr;   Packet* sendEncapsulatedPkptr;   int packetType;   int strmIndex;      #define ACK 0   #define DATA_PACKET 1   #define SRC_INDEX 0   #define RX_INDEX 1   #define TX_INDEX 1   #define SINK_INDEX 0   #define HIGH_PRIORITY 1   #define LOW_PRIORITY 0           9#define PowerUp			(op_intrpt_type() == OPC_INTRPT_BEGSIM)   7#define Timeout 		(op_intrpt_type() == OPC_INTRPT_SELF)   :#define ReceivePkt  	(op_intrpt_type() == OPC_INTRPT_STRM)   =#define QHEmpty			(op_subq_empty(HIGH_PRIORITY) == OPC_TRUE)    ;#define QLEmpty			(op_subq_empty(LOW_PRIORITY) == OPC_TRUE)   
   int flipBit(int x) {   	FIN(flipBit(x));   	if (x == 0) {   		x = 1;   	}   	else {   		x = 0;   	}   		FRET(x);   }                                                Z          
   Init   
                     
      eRetransmissionsStat = op_stat_reg("Retransmissions Per Packet", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   eRetransmissionsTotalStat = op_stat_reg("Retransmissions Total", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   Aop_ima_obj_attr_get(op_id_self(), "TimeoutValue", &TimeoutValue);   
SentN = 0;   	RecN = 0;   Retransmissions = 0;   RetransmissionsTotal = 0;   
       
   ����   
          pr_state                    
   Idle   
                                       ����             pr_state          v          
   WaitAck   
                                       ����             pr_state          �          
   st_3   
       
   *   Packet* receivedPkptr;   Packet* pkptr;   Packet* ackPkptr;   int packetTypeIncoming;   int checkSequence;       strmIndex = op_intrpt_strm();   %receivedPkptr = op_pk_get(strmIndex);       if (strmIndex == SRC_INDEX){   6	pkptr = op_pk_create_fmt("Assignment3_packetformat");   1	op_pk_nfd_set(pkptr, "packetType", DATA_PACKET);   %	op_pk_nfd_set(pkptr, "seqN", SentN);   5	op_pk_nfd_set(pkptr, "user_packets", receivedPkptr);   $	PreviousPacket = op_pk_copy(pkptr);   	op_pk_send(pkptr,TX_INDEX);   	SentN = flipBit(SentN);   	       B	Timer = op_intrpt_schedule_self(op_sim_time() + TimeoutValue, 0);   	    }   else {   A	op_pk_nfd_get(receivedPkptr, "packetType", &packetTypeIncoming);    	if(packetTypeIncoming == ACK) {   		op_pk_destroy(receivedPkptr);   		} else {   5		op_pk_nfd_get(receivedPkptr,"seqN",&checkSequence);   		if (checkSequence == RecN){   7			op_pk_nfd_get(receivedPkptr,"user_packets", &pkptr);   	   !			op_pk_send(pkptr, SINK_INDEX);   ;			ackPkptr = op_pk_create_fmt("Assignment3_packetformat");   .			op_pk_nfd_set(ackPkptr, "packetType", ACK);   			RecN = flipBit(RecN);   )			op_pk_nfd_set(ackPkptr, "seqN", RecN);   "			op_pk_send(ackPkptr, TX_INDEX);   			   		}   		op_pk_destroy(receivedPkptr);   	}   }   
                     
   ����   
          pr_state        �  V          
   Q>0   
       
   A   //Packet* pkptr;   //Packet* sendPkptr;   //Packet* ackPkptr;   //int priority;   //int packetType;   //int ackN;       //strmIndex = op_intrpt_strm();   //pkptr = op_pk_get(strmIndex);                   5//op_pk_nfd_access(pkptr, "packetType", &packetType);   )//op_pk_nfd_access(pkptr, "seqN", &ackN);       /*   if (packetType != ACK) {   2	op_pk_nfd_get(pkptr, "user_packets", &sendPkptr);   #	op_pk_send(sendPkptr, SINK_INDEX);   		   9	ackPkptr = op_pk_create_fmt("Assignment3_packetformat");   	RecN = flipBit(RecN);   ,	op_pk_nfd_set(ackPkptr, "packetType", ACK);   '	op_pk_nfd_set(ackPkptr, "seqN", RecN);    	op_pk_send(ackPkptr, TX_INDEX);   	op_pk_destroy(pkptr);   }   */       if (ackN == SentN) {    	op_ev_cancel_if_pending(Timer);   5	op_stat_write(RetransmissionsStat, Retransmissions);   	Retransmissions = 0;   	// check high priority queue   	if (!QHEmpty){   >		sendPkptr = op_subq_pk_remove(HIGH_PRIORITY, OPC_QPOS_HEAD);   G		sendEncapsulatedPkptr = op_pk_create_fmt("Assignment3_packetformat");   B		op_pk_nfd_set(sendEncapsulatedPkptr, "packetType", DATA_PACKET);   6		op_pk_nfd_set(sendEncapsulatedPkptr, "seqN", SentN);   B		op_pk_nfd_set(sendEncapsulatedPkptr, "user_packets", sendPkptr);   5		PreviousPacket = op_pk_copy(sendEncapsulatedPkptr);   .		op_pk_send(sendEncapsulatedPkptr, TX_INDEX);   		SentN = flipBit(SentN);   C		Timer = op_intrpt_schedule_self(op_sim_time() + TimeoutValue, 0);   	}   	// check low priority queue   	else if (!QLEmpty){   =		sendPkptr = op_subq_pk_remove(LOW_PRIORITY, OPC_QPOS_HEAD);   G		sendEncapsulatedPkptr = op_pk_create_fmt("Assignment3_packetformat");   B		op_pk_nfd_set(sendEncapsulatedPkptr, "packetType", DATA_PACKET);   6		op_pk_nfd_set(sendEncapsulatedPkptr, "seqN", SentN);   B		op_pk_nfd_set(sendEncapsulatedPkptr, "user_packets", sendPkptr);   5		PreviousPacket = op_pk_copy(sendEncapsulatedPkptr);   .		op_pk_send(sendEncapsulatedPkptr, TX_INDEX);   		SentN = flipBit(SentN);   C		Timer = op_intrpt_schedule_self(op_sim_time() + TimeoutValue, 0);   	}   	   }   else {   	op_pk_destroy(pkptr);   }       	   
                     
   ����   
          pr_state         �  V          
   Q=0   
       
      //op_pk_destroy(sendPkptr);       if (ackN == SentN) {   	   	op_pk_destroy(pkptr);        	op_ev_cancel_if_pending(Timer);   5	op_stat_write(RetransmissionsStat, Retransmissions);   	Retransmissions = 0;       } else {   	op_pk_destroy(pkptr);   }   
                     
   ����   
          pr_state          *          
   GetPacketType   
       
      strmIndex = op_intrpt_strm();   pkptr = op_pk_get(strmIndex);                   
                     
   ����   
          pr_state         �  �          
   st_7   
       
      int priority;   0op_pk_nfd_access(pkptr, "priority", &priority);	   2op_subq_pk_insert(priority, pkptr, OPC_QPOS_TAIL);   
                     
   ����   
          pr_state        J  �          
   st_8   
       
      3op_pk_nfd_access(pkptr, "packetType", &packetType);   'op_pk_nfd_access(pkptr, "seqN", &ackN);       
                     
   ����   
          pr_state      	  �  �          
   st_9   
       
      Packet* ackPkptr;   int checkSequence;   -op_pk_nfd_get(pkptr, "seqN", &checkSequence);       if (checkSequence == RecN) {   2	op_pk_nfd_get(pkptr, "user_packets", &sendPkptr);   #	op_pk_send(sendPkptr, SINK_INDEX);   9	ackPkptr = op_pk_create_fmt("Assignment3_packetformat");   	RecN = flipBit(RecN);   ,	op_pk_nfd_set(ackPkptr, "packetType", ACK);   '	op_pk_nfd_set(ackPkptr, "seqN", RecN);    	op_pk_send(ackPkptr, TX_INDEX);       }   	   op_pk_destroy(pkptr);   
                     
   ����   
          pr_state      
  �  �          
   st_10   
       
   	   op_ev_cancel_if_pending(Timer);       Retransmissions++;   RetransmissionsTotal++;   >op_stat_write(RetransmissionsTotalStat, RetransmissionsTotal);       1op_pk_send(op_pk_copy(PreviousPacket), TX_INDEX);   ATimer = op_intrpt_schedule_self(op_sim_time() + TimeoutValue, 0);       
                     
   ����   
          pr_state                       	   �        i     �          
   tr_0   
       
   PowerUp   
       ����          
    ����   
          ����                       pr_transition                k            �          
   tr_2   
       
   
ReceivePkt   
       ����          
    ����   
          ����                       pr_transition               �  0       �    Z          
   tr_3   
       
   strmIndex == SRC_INDEX   
       ����          
    ����   
          ����                       pr_transition               �  �      �  `����  �     �          
   tr_8   
       
   ackN == SentN   
       ����          
    ����   
          ����                       pr_transition      	        
  �     	  �              
   tr_9   
       
   
ReceivePkt   
       ����          
    ����   
          ����                       pr_transition              �  v     �  b  `  �  W  _    g          
   tr_12   
       ����          ����          
    ����   
          ����                       pr_transition               �  s       ;   �  �          
   tr_13   
       
   strmIndex == SRC_INDEX   
       ����          
    ����   
          ����                       pr_transition              R  Z       9  K  �          
   tr_14   
       
   strmIndex == RX_INDEX   
       ����          
    ����   
          ����                       pr_transition               �  _      �  �   �     �  c          
   tr_15   
       ����          ����          
    ����   
          ����                       pr_transition              1  $     G  �   �  L          
   tr_16   
       
   'QHEmpty && QLEmpty && packetType == ACK   
       ����          
    ����   
          ����                       pr_transition              �  �     P  �  �  E          
   tr_17   
       
   +(!QHEmpty || !QLEmpty) && packetType == ACK   
       ����          
    ����   
          ����                       pr_transition            	  �  �     S  �  �  �          
   tr_18   
       
   packetType != ACK   
       ����          
    ����   
          ����                       pr_transition         	     �  �     �  �    d          
   tr_19   
       ����          ����          
    ����   
          ����                       pr_transition            
  �  �       f    �          
   tr_20   
       
   Timeout   
       ����          
    ����   
          ����                       pr_transition         
     �  �     �  �    n          
   tr_21   
       ����          ����          
    ����   
          ����                       pr_transition              �  �       �  �  �  �   �              
   tr_27   
       
   strmIndex != SRC_INDEX   
       ����          
    ����   
          ����                       pr_transition               o  E      �  f   {  n   '    
  c          
   tr_28   
       
   ackN != SentN   
       ����          
    ����   
          ����                       pr_transition                   Retransmissions Per Packet        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}   Retransmissions Total        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}                            