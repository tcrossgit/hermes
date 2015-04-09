---------------------------------------------------------------------------
-- FILE    : hermes-der-encode.adb
-- SUBJECT : Body of a package for encoding DER encoded data.
-- AUTHOR  : (C) Copyright 2015 by Peter Chapin
--
-- Please send comments or bug reports to
--
--      Peter Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
pragma SPARK_Mode(On);

package body Hermes.DER.Encode is

   function Make_Leading_Identifier
     (Tag_Class       : Tag_Class_Type;
      Structured_Flag : Structured_Flag_Type;
      Tag             : Leading_Number_Type) return Octet is

      Tag_Class_Lookup_Table : constant array(Tag_Class_Type) of Octet :=
        (Class_Universal        => 2#0000_0000#,
         Class_Application      => 2#0100_0000#,
         Class_Context_Specific => 2#1000_0000#,
         Class_Private          => 2#1100_0000#);

      Structured_Flag_Lookup_Table : constant array(Structured_Flag_Type) of Octet :=
        (Primitive              => 2#0000_0000#,
         Constructed            => 2#0010_0000#);

      Leading_Number_Lookup_Table : constant array(Leading_Number_Type) of Octet :=
        (Tag_Reserved           =>  0,
         Tag_Boolean            =>  1,
         Tag_Integer            =>  2,
         Tag_Bit_String         =>  3,
         Tag_Octet_String       =>  4,
         Tag_Null               =>  5,
         Tag_Object_Identifier  =>  6,
         Tag_Object_Descriptor  =>  7,
         Tag_Instance_Of        =>  8,
         Tag_External           =>  8,  -- Same as Instance_Of
         Tag_Real               =>  9,
         Tag_Enumerated         => 10,
         Tag_Embedded_PDV       => 11,
         Tag_UTF8_String        => 12,
         Tag_Relative_OID       => 13,
         -- Values 14 .. 15 omitted (not defined?)
         Tag_Sequence           => 16,
         Tag_Sequence_Of        => 16,  -- Same as Sequence
         Tag_Set                => 17,
         Tag_Set_Of             => 17,  -- Same as Set
         Tag_Numeric_String     => 18,
         Tag_Printable_String   => 19,
         Tag_Teletex_String     => 20,
         Tag_T61_String         => 20,  -- Same as Teletex_String
         Tag_Videotex_String    => 21,
         Tag_IA5_String         => 22,
         Tag_UTC_Time           => 23,
         Tag_Generalized_Time   => 24,
         Tag_Graphic_String     => 25,
         Tag_Visible_String     => 26,
         Tag_ISO646_String      => 26,  -- Same as Visible_String
         Tag_General_String     => 27,
         Tag_Universal_String   => 28,
         Tag_Character_String   => 29,
         Tag_BMP_String         => 30,
         Tag_EXTENDED_TAG       => 31);

   begin
      return
        Tag_Class_Lookup_Table(Tag_Class)             or
        Structured_Flag_Lookup_Table(Structured_Flag) or
        Leading_Number_Lookup_Table(Tag);
   end Make_Leading_Identifier;

-- Put_Length
   function Put_Length_Value(Length : Natural) return Hermes.Octet_Array is
      Dummy : Hermes.Octet_Array(1..0):= (others => 0);
   begin
      if(Length >= 0 and Length <= 127) then         
         Dummy := (Dummy'First => Hermes.Octet(Length));  
      elsif(Length > 127) then
         Dummy := (Dummy'First + 1 => Hermes.Octet(Length));
         
         if(Length <= 2**8 and Length < 2**16) then 
            Dummy := (Dummy'First => 2#1000_0010#);
         elsif(Length >= 2**16 and Length < 2**24) then   
            Dummy := (Dummy'First => 2#1000_0011#);
         elsif(Length >= 2**24 and Length < Natural'Last) then         
            Dummy := (Dummy'First => 2#1000_0100#);                                          
         end if;       
      end if;
      
 --     raise Program_Error with "Hermes.DER.Encode.Put_Length_Value not implemented";
      return Dummy;
   end Put_Length_Value;
   
   function Put_Boolean_Value(Value : Boolean) return Hermes.Octet_Array is      
       Boolean_Octet_Array  : Hermes.Octet_Array(1..3);
       Boolean_Value_Octet  : Hermes.Octet := 0;
   begin   
      
       if Value = False then
          Boolean_Value_Octet := 2#0000_0000#;
       elsif Value = True then
          Boolean_Value_Octet := 2#1111_1111#;
       end if;
 
       Boolean_Octet_Array :=
            (Make_Leading_Identifier(Tag_Class => Class_Universal,
                                     Structured_Flag => Primitive,
                                     Tag => Tag_Boolean)
             & 2#0000_0001#       --set length(length won't change for boolean
             & Boolean_Value_Octet);
      
 --        raise Program_Error with "Hermes.DER.Encode.Put_Boolean_Value not imp
       return Boolean_Octet_Array;
    end Put_Boolean_Value;

--Put_Integer_Value
   function Put_Integer_Value(Value : Integer) return Hermes.Octet_Array is
      Integer_Octet_Array  : Hermes.Octet_Array(1..0):= (others => 0);
      Neg_Value : Integer := -(Value);
      Temp_Octet : Hermes.Octet;
   begin
      --put tag for integer,create octet
      if Value >= 0 and 2#1000_0000# /= 1 then      
         Integer_Octet_Array := Make_Leading_Identifier(Tag_Class       => Class_Universal,                      
                                                        Structured_Flag => Primitive,
                                                        Tag             => Tag_Integer)
        & Put_Length_Value(Value'Size)
           & Hermes.Octet(Value);
      elsif Value > 0 and 2#1000_0000# = 1 then
         Integer_Octet_Array := Make_Leading_Identifier(Tag_Class       => Class_Universal,                      
                                                        Structured_Flag => Primitive,
                                                        Tag             => Tag_Integer)
           & Put_Length_Value(Value'Size)
           & 2#0000_0000# 
           & Hermes.Octet(Value);
      elsif Value < 0 then
--           Neg_Value := Value * (-1);-- make positive
         Temp_Octet := Octet'Val(Integer'Pos(Neg_Value));-- convert
         Temp_Octet := Temp_Octet xor 2#1111_1111#;-- invert bits
         Temp_Octet := Temp_Octet + 2#1#;-- add one 
         
         
         Integer_Octet_Array := Make_Leading_Identifier(Tag_Class       => Class_Universal,                      
                                                        Structured_Flag => Primitive,
                                                        Tag             => Tag_Integer)
           & Put_Length_Value(Value'Size)
           & Temp_Octet;
      end if;
       
      --        raise Program_Error with "Hermes.DER.Encode.Put_Integer_Value not implemented";
      return Integer_Octet_Array;
   end Put_Integer_Value;

--Put_Null                                
   function Put_Null_Value return Hermes.Octet_Array is
      Null_Octet_Array  : Hermes.Octet_Array(1..0); 
   begin
      Null_Octet_Array := (Make_Leading_Identifier(Tag_Class       => Class_Universal,
                                                   Structured_Flag => Primitive,
                                                   Tag             => Tag_Null) 
                           & 2#0000_0000#);     
                                 
      return Null_Octet_Array;
      end Put_Null_Value;
   
   
end Hermes.DER.Encode;

