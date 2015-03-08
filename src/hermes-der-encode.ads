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

end Hermes.DER.Encode;

