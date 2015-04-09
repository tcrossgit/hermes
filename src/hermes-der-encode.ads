---------------------------------------------------------------------------
-- FILE    : hermes-der-encode.ads
-- SUBJECT : Specification of a package for encoding DER encoded data.
-- AUTHOR  : (C) Copyright 2015 by Peter Chapin
--
-- Please send comments or bug reports to
--
--      Peter Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
pragma SPARK_Mode(On);

package Hermes.DER.Encode is
   
   -- Constructs an identifier octet from its constituent parts.
   function Make_Leading_Identifier
     (Tag_Class       : Tag_Class_Type;
      Structured_Flag : Structured_Flag_Type;
      Tag             : Leading_Number_Type) return Octet;
   
   -- Returns the DER encoded length.
   function Put_Length_Value(Length : Natural) return Hermes.Octet_Array
     with
   Pre => Length in Natural'Range;
   
   -- Returns the DER encoded TLV triple of a Boolean value.
   function Put_Boolean_Value(Value : Boolean) return Hermes.Octet_Array;

   -- Returns the DER encoded TLV triple of an integer value.
   function Put_Integer_Value(Value : Integer) return Hermes.Octet_Array
     with
   Pre => Value in Integer'Range;
   
   --Returns DER encoded TLV triple of an integer value.
--     for Tag_Null = 5 NOT 14 & 15, didn't know if 
--     I should include these other two into Put_Null or not 
   function Put_Null_Value return Hermes.Octet_Array;
   
end Hermes.DER.Encode;

