MIL_3_Tfile_Hdr_ 1871 175A modeler 9 5F2932DD 61DB61B6 11 DTU-5CG8190KT2 larst 0 0 none none 0 0 none 43D450C1 13FB 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                            ??g?      D  A  E      ?  6  :  ?  ?  ?  ?  ?  ?  ?      IntervalType    ???????    ????              Constant          ????          ????         Constant       ????      Uniform      ????      Exponential      ????       ?Z                Constant(0)       or       
Uniform(1)       or       Exponential(2)   IntervalTime   ???????   ????       @      ????              ????              ????           ?Z                Used       both       by       constant       (exact       time)       and       others       (avg       between       pkts)   MinPacketSize    ???????    ????          ????          ????          ????           ?Z             MaxPacketSize    ???????    ????          ????          ????          ????           ?Z                 	   begsim intrpt         
   ????   
   doc file            	nd_module      endsim intrpt             ????      failure intrpts            disabled      intrpt interval         ԲI?%??}????      priority              ????      recovery intrpts            disabled      subqueue                     count    ???   
   ????   
      list   	???   
          
      super priority             ????             int	\IntervalType;       double	\IntervalTime;       int	\MinPacketSize;       int	\MaxPacketSize;       int	\PacketsGenerated;       int	\BitsGenerated;       Stathandle	\PacketStat;       Stathandle	\BitStat;              #define INTERVAL_CONSTANT 		0   #define INTERVAL_UNIFORM 		1    #define INTERVAL_EXPONENTIAL 	2	       /* EVENTS */    9#define PowerUp			(op_intrpt_type() == OPC_INTRPT_BEGSIM)   :#define InitTimeout 	(op_intrpt_type() == OPC_INTRPT_SELF)   =#define IntervalTimeout (op_intrpt_type() == OPC_INTRPT_SELF)       /* ACTIONS */   \#define StartInitTimer 	op_intrpt_schedule_self(op_sim_time() + op_dist_exponential(10), 0);                                                      Z   Z          
   Init   
                     
      // Read attributes   Aop_ima_obj_attr_get(op_id_self(), "IntervalType", &IntervalType);   Aop_ima_obj_attr_get(op_id_self(), "IntervalTime", &IntervalTime);   Cop_ima_obj_attr_get(op_id_self(), "MinPacketSize", &MinPacketSize);   Cop_ima_obj_attr_get(op_id_self(), "MaxPacketSize", &MaxPacketSize);       // Register statistics   MPacketStat = op_stat_reg("PacketStat", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);    FBitStat = op_stat_reg("BitStat", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       // Initialize counters   PacketsGenerated = 0;   BitsGenerated = 0;    
       
   ????   
          pr_state           Z          
   IdleInit   
       
       
       
       
           ????             pr_state        ?   Z          
   Idle   
       
      //generating packet   Packet* pkptr;   int PacketSize;       %if (MinPacketSize >= MaxPacketSize) {   	PacketSize = MinPacketSize;   } else {   ;	PacketSize = op_dist_uniform(MaxPacketSize-MinPacketSize);   	PacketSize += MinPacketSize;   }       !pkptr = op_pk_create(PacketSize);   PacketsGenerated++;   BitsGenerated += PacketSize;       ,op_stat_write(PacketStat, PacketsGenerated);   &op_stat_write(BitStat, BitsGenerated);       op_pk_send(pkptr, 0);       //starting interval timer   (if (IntervalType == INTERVAL_CONSTANT) {   :	op_intrpt_schedule_self(op_sim_time() + IntervalTime, 0);   .} else if (IntervalType == INTERVAL_UNIFORM) {   L	op_intrpt_schedule_self(op_sim_time() + op_dist_uniform(IntervalTime*2),0);   } else {   O	op_intrpt_schedule_self(op_sim_time() + op_dist_exponential(IntervalTime), 0);   }       
                         ????             pr_state                        ?   R      h   [   ?   [          
   tr_0   
       
   PowerUp   
       
   StartInitTimer   
       
    ????   
          ????                       pr_transition              J   O        [  v   [          
   tr_1   
       
   InitTimeout   
       
????   
       
    ????   
          ????                       pr_transition              ?   $   	  ?   O  ?   7  ?   .  ?   =  ?   ^  ?   v  ?   |  ?   s  ?   d          
   tr_2   
       
   IntervalTimeout   
       
????   
       
    ????   
          ????                       pr_transition                   
PacketStat        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}   BitStat        ????????????        ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}ԲI?%??}                            