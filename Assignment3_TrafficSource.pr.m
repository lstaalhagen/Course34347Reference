MIL_3_Tfile_Hdr_ 1871 175A modeler 9 5F310958 5F3256DB 14 DTU-CZC8338FC1 s164146 0 0 none none 0 0 none 24EBFE62 1956 0 0 0 0 0 0 8e 0                                                                                                                                                                                                                                                                                                                                                                                          ��g�      D  S  W    #  q  '  +  :  >  J  N  R  a  m      IntervalType    �������    ����              Constant          ����          ����         Constant       ����      Uniform      ����      Exponential      ����       �Z                Constant(0)       or       
Uniform(1)       or       Exponential(2)   PriorityFraction   �������   ����       ?�      ����              ����              ����           �Z             
PacketRate   �������   ����       ?�      ����              ����              ����           �Z                 	   begsim intrpt         
   ����   
   doc file            	nd_module      endsim intrpt         
   ����   
   failure intrpts            disabled      intrpt interval         ԲI�%��}����      priority              ����      recovery intrpts            disabled      subqueue                     count    ���   
   ����   
      list   	���   
          
      super priority             ����             int	\IntervalType;       double	\IntervalTime;       int	\PacketsGenerated;       Stathandle	\PacketStat;       double	\PriorityFraction;       double	\PacketRate;       int	\LowPriority;       int	\HighPriority;       Stathandle	\LowPriorityStat;       Stathandle	\HighPriorityStat;              #define INTERVAL_CONSTANT 		0   #define INTERVAL_UNIFORM 		1    #define INTERVAL_EXPONENTIAL 	2	       /* EVENTS */    9#define PowerUp			(op_intrpt_type() == OPC_INTRPT_BEGSIM)   :#define InitTimeout 	(op_intrpt_type() == OPC_INTRPT_SELF)   =#define IntervalTimeout (op_intrpt_type() == OPC_INTRPT_SELF)       /* ACTIONS */   \#define StartInitTimer 	op_intrpt_schedule_self(op_sim_time() + op_dist_exponential(10), 0);       ;#define PowerDown 		(op_intrpt_type() == OPC_INTRPT_ENDSIM)                                                  �            
   Init   
                     
      Aop_ima_obj_attr_get(op_id_self(), "IntervalType", &IntervalType);       C//op_ima_obj_attr_get(op_id_self(), "IntervalTime", &IntervalTime);       Iop_ima_obj_attr_get(op_id_self(), "PriorityFraction", &PriorityFraction);       =op_ima_obj_attr_get(op_id_self(), "PacketRate", &PacketRate);           MPacketStat = op_stat_reg("PacketStat", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);        [LowPriorityStat = op_stat_reg("Low Priority Packets", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);   ]HighPriorityStat = op_stat_reg("High Priority Packets", OPC_STAT_INDEX_NONE, OPC_STAT_LOCAL);       PacketsGenerated = 0;   LowPriority = 0;   HighPriority = 0;       
       
   ����   
          pr_state         �  �          
   IdleInit   
       
          if (PacketRate > 0.0) {   	IntervalTime = 1/PacketRate;     }    
       
       
           ����             pr_state         �  v          
   Idle   
       
   $   //generating packet   Packet* pkptr;   double randomValue;   int priority;       !randomValue = op_dist_uniform(1);       $if (randomValue > PriorityFraction){   	priority = 0;   	LowPriority++;   -	op_stat_write(LowPriorityStat, LowPriority);   } else {   	priority = 1;   	HighPriority++;   /	op_stat_write(HighPriorityStat, HighPriority);   }       (pkptr = op_pk_create_fmt("user_packet");   +op_pk_nfd_set(pkptr, "priority", priority);       PacketsGenerated++;       ,op_stat_write(PacketStat, PacketsGenerated);       op_pk_send(pkptr, 0);       //starting interval timer   (if (IntervalType == INTERVAL_CONSTANT) {   :	op_intrpt_schedule_self(op_sim_time() + IntervalTime, 0);   .} else if (IntervalType == INTERVAL_UNIFORM) {   L	op_intrpt_schedule_self(op_sim_time() + op_dist_uniform(IntervalTime*2),0);   } else {   O	op_intrpt_schedule_self(op_sim_time() + op_dist_exponential(IntervalTime), 0);   }       ;printf("Type: %d , Time: %d\n",IntervalType, IntervalTime);   
                         ����             pr_state        J  �          
   Endsim   
       
      ,op_stat_write(PacketStat, PacketsGenerated);   ,op_stat_write(LowPriorityStat, LowPriority);   .op_stat_write(HighPriorityStat, HighPriority);   
                     
    ����   
          pr_state                        f  T      �  !   �  �          
   tr_0   
       
   PowerUp && PacketRate > 0.0   
       
   StartInitTimer   
       
    ����   
          ����                       pr_transition               �        �  �   �  _          
   tr_1   
       
   InitTimeout   
       
����   
       
    ����   
          ����                       pr_transition               Y  �      �  �   =     �     �  w   �  �          
   tr_2   
       
   IntervalTimeout   
       
����   
       
    ����   
          ����                       pr_transition                 \      �     �  P   �  �          
   tr_4   
       
   PowerUp && PacketRate == 0.0   
       ����          
    ����   
          ����                       pr_transition                �      �  �  @  �          
   tr_5   
       
   	PowerDown   
       ����          
    ����   
          ����                       pr_transition              t  �     U  �  �  !  �  }  K  �          
   tr_8   
       ����          ����          
    ����   
          ����                       pr_transition      	         R  �      �  �   C       �   �  �          
   tr_9   
       
   PacketRate == 0.0   
       ����          
    ����   
          ����                       pr_transition         
          
PacketStat        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}   Low Priority Packets        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}   High Priority Packets        ������������        ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}ԲI�%��}                            