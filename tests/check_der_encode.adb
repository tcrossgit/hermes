---------------------------------------------------------------------------
-- FILE    : check_der_encode.adb
-- SUBJECT : Package containing tests of ASN.1 DER encoding.
-- AUTHOR  : (C) Copyright 2015 by Peter Chapin
--
-- Please send comments or bug reports to
--
--      Peter Chapin <PChapin@vtc.vsc.edu>
---------------------------------------------------------------------------
with AUnit.Assertions;
with Hermes.DER.Encode;

use AUnit.Assertions;
use Hermes;
use Hermes.DER;
use Hermes.DER.Encode;

package body Check_DER_Encode is

   type Octet_Array_Access is access Octet_Array;

   procedure Test_Put_Length(T : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      null;
   end Test_Put_Length;


   procedure Test_Put_Integer(T : in out AUnit.Test_Cases.Test_Case'Class) is
   begin
      null;
   end Test_Put_Integer;


   procedure Register_Tests(T : in out DER_Encode_Test) is
   begin
      AUnit.Test_Cases.Registration.Register_Routine(T, Test_Put_Length'Access, "Put Length");
      AUnit.Test_Cases.Registration.Register_Routine(T, Test_Put_Integer'Access, "Put Integer");
   end Register_Tests;


   function Name(T : DER_Encode_Test) return AUnit.Message_String is
   begin
      return AUnit.Format("DER.Encode");
   end Name;

end Check_DER_Encode;
