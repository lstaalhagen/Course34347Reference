MIL_3_Tfile_Hdr_ 1871 175A modeler 9 61DB5E20 61E1569C E DTU-5CG8190KT2 larst 0 0 none none 0 0 none 1093980E 1802 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                             ??g?      D  F  J      ?      ?  ?  ?  ?  ?  ?  ?      	MyAddress    ???????    ????       ????   Auto Assign          ????          ????         Auto Assign   ????????       ?Z             ExcludeSelf   ???????   ????           ????          ????          ????           ?Z                 	   begsim intrpt         
   ????   
   doc file            	nd_module      endsim intrpt             ????      failure intrpts            disabled      intrpt interval         ԲI?%??}????      priority              ????      recovery intrpts            disabled      subqueue                     count    ???   
   ????   
      list   	???   
          
      super priority             ????             "OmsT_Aa_Address_Handle	\aa_handle;       int	\my_address;       int	\packets_received;       int	\packets_dropped;       "Stathandle	\stat_packets_received;       !Stathandle	\stat_packets_dropped;       int	\exclude_self;              ##include "oms_auto_addr_support.h"        #define STRM_FROM_SRC     0   #define STRM_FROM_RX      1   #define STRM_TO_TX        0   #define STRM_TO_SINK      1       7#define PowerUp (op_intrpt_type() == OPC_INTRPT_BEGSIM)   X#define SRC (op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm() == STRM_FROM_SRC)   V#define RX (op_intrpt_type() == OPC_INTRPT_STRM) && (op_intrpt_strm() == STRM_FROM_RX)                                                                  Z   ?          
   Init   
       J      @op_ima_obj_attr_get(op_id_self(), "ExcludeSelf", &exclude_self);       ]stat_packets_received = op_stat_reg("Packets received", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   [stat_packets_dropped = op_stat_reg("Packets dropped", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       packets_received = 0;   packets_dropped = 0;   J                     
   ????   
          pr_state         ?   ?          
   AA1   
       
      9aa_handle = oms_aa_address_handle_get("MAC","MyAddress");       )op_intrpt_schedule_self(op_sim_time(),0);   
                         ????             pr_state        J   ?          
   AA2   
       
      <op_ima_obj_attr_get(op_id_self(), "MyAddress", &my_address);   =oms_aa_address_resolve(aa_handle, op_id_self(), &my_address);   )op_intrpt_schedule_self(op_sim_time(),0);   
       J      ;op_ima_obj_attr_get(op_id_self(),"MyAddress",&my_address);    2// printf("My unique address is:%d\n",my_address);   J           ????             pr_state        ?   ?          
   Idle   
                                       ????             pr_state        ?   Z          
   FromSRC   
       
      int destination;   Packet * srcpkt;   Packet * macpkt;       %srcpkt = op_pk_get(op_intrpt_strm());   'macpkt = op_pk_create_fmt("MAC_Frame");   )op_pk_nfd_set(macpkt, "Payload", srcpkt);       '// Determine random destination station   if (exclude_self)   	{   	destination = my_address;   "	while (destination == my_address)   		{   $		destination = OMSC_AA_AUTO_ASSIGN;   0		oms_aa_dest_addr_get(aa_handle, &destination);   		}   	}   else   	{   #	destination = OMSC_AA_AUTO_ASSIGN;   /	oms_aa_dest_addr_get(aa_handle, &destination);   	}   	   -op_pk_nfd_set(macpkt, "SrcAddr", my_address);   .op_pk_nfd_set(macpkt, "DstAddr", destination);       op_pk_send(macpkt, STRM_TO_TX);   
                     
   ????   
          pr_state        ?  J          
   FromRX   
       
      Packet * macpkt;   Packet * usrpkt;   int dstaddr;       %macpkt = op_pk_get(op_intrpt_strm());   +op_pk_nfd_get(macpkt, "DstAddr", &dstaddr);       if (dstaddr == my_address)   	{   +	op_pk_nfd_get(macpkt, "Payload", &usrpkt);   "	op_pk_send(usrpkt, STRM_TO_SINK);   	}   else   	{   	packets_dropped++;   6	op_stat_write(stat_packets_dropped, packets_dropped);   	}       packets_received++;   7op_stat_write(stat_packets_received, packets_received);       op_pk_destroy(macpkt);   
                     
   ????   
          pr_state                        ?   ?      n   ?   ?   ?          
   tr_0   
       
   PowerUp   
       ????          
    ????   
          ????                       pr_transition               ?   ?      ?   ?  Z   ?          
   tr_1   
       ????          ????          
    ????   
          ????                       pr_transition               ?   ?     ]   ?  ?   ?          
   tr_2   
       ????          ????          
    ????   
          ????                       pr_transition              ?   ?     ?   ?  ?   ?  ?   j          
   tr_8   
       
   SRC   
       ????          
    ????   
          ????                       pr_transition      	        `   H     ?   m  ?   ?  ?   ?          
   tr_9   
       ????          ????          
    ????   
          ????                       pr_transition      
        ?       ?   ?  ?    ?  3          
   tr_10   
       
   RX   
       ????          
    ????   
          ????                       pr_transition              6   ?     ?  6  ?    ?   ?          
   tr_11   
       ????          ????          
    ????   
          ????                       pr_transition                   Packets received        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   Packets dropped        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}          oms_auto_addr_support                    