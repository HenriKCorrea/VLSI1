--------------------------------------------------
-- File:    decoder_scancode_ascii_map.vhd
-- Author:  Prof. M.Sc. Marlon Moraes
-- E-mail:  marlon.moraes@pucrs.br
--------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
use UNISIM.VPKG.ALL;

entity decoder_scancode_ascii_map is
  port (
    ascii_out : out STD_LOGIC_VECTOR ( 7 downto 0 ); 
    scancode_in : in STD_LOGIC_VECTOR ( 7 downto 0 ) 
  );
end decoder_scancode_ascii_map;

architecture Structure of decoder_scancode_ascii_map is
  signal N37 : STD_LOGIC; 
  signal N38 : STD_LOGIC; 
  signal N4 : STD_LOGIC; 
  signal N40 : STD_LOGIC; 
  signal N42 : STD_LOGIC; 
  signal N46 : STD_LOGIC; 
  signal N5 : STD_LOGIC; 
  signal N50 : STD_LOGIC; 
  signal N52 : STD_LOGIC; 
  signal N56 : STD_LOGIC; 
  signal N58 : STD_LOGIC; 
  signal N6 : STD_LOGIC; 
  signal N62 : STD_LOGIC; 
  signal N64 : STD_LOGIC; 
  signal N68 : STD_LOGIC; 
  signal N70 : STD_LOGIC; 
  signal N71 : STD_LOGIC; 
  signal N72 : STD_LOGIC; 
  signal N73 : STD_LOGIC; 
  signal N75 : STD_LOGIC; 
  signal ascii_out_0_128 : STD_LOGIC; 
  signal ascii_out_0_1281_22 : STD_LOGIC; 
  signal ascii_out_0_1282_23 : STD_LOGIC; 
  signal ascii_out_0_15_24 : STD_LOGIC; 
  signal ascii_out_0_35_25 : STD_LOGIC; 
  signal ascii_out_0_6 : STD_LOGIC; 
  signal ascii_out_0_74 : STD_LOGIC; 
  signal ascii_out_0_741_28 : STD_LOGIC; 
  signal ascii_out_0_742_29 : STD_LOGIC; 
  signal ascii_out_1_123_31 : STD_LOGIC; 
  signal ascii_out_1_137_32 : STD_LOGIC; 
  signal ascii_out_1_152_33 : STD_LOGIC; 
  signal ascii_out_1_29_34 : STD_LOGIC; 
  signal ascii_out_1_48_35 : STD_LOGIC; 
  signal ascii_out_1_61_36 : STD_LOGIC; 
  signal ascii_out_1_77_37 : STD_LOGIC; 
  signal ascii_out_1_8_38 : STD_LOGIC; 
  signal ascii_out_2_110 : STD_LOGIC; 
  signal ascii_out_2_1101_41 : STD_LOGIC; 
  signal ascii_out_2_1102_42 : STD_LOGIC; 
  signal ascii_out_2_125 : STD_LOGIC; 
  signal ascii_out_2_1251_44 : STD_LOGIC; 
  signal ascii_out_2_15 : STD_LOGIC; 
  signal ascii_out_2_151_46 : STD_LOGIC; 
  signal ascii_out_2_152_47 : STD_LOGIC; 
  signal ascii_out_2_61_48 : STD_LOGIC; 
  signal ascii_out_3_131_50 : STD_LOGIC; 
  signal ascii_out_3_18 : STD_LOGIC; 
  signal ascii_out_3_181 : STD_LOGIC; 
  signal ascii_out_3_182_53 : STD_LOGIC; 
  signal ascii_out_3_68_54 : STD_LOGIC; 
  signal ascii_out_3_68_SW0 : STD_LOGIC; 
  signal ascii_out_3_68_SW01_56 : STD_LOGIC; 
  signal ascii_out_3_84_57 : STD_LOGIC; 
  signal ascii_out_4_12_59 : STD_LOGIC; 
  signal ascii_out_4_38_60 : STD_LOGIC; 
  signal ascii_out_4_56_61 : STD_LOGIC; 
  signal ascii_out_5_16_63 : STD_LOGIC; 
  signal ascii_out_5_21 : STD_LOGIC; 
  signal ascii_out_5_35 : STD_LOGIC; 
  signal ascii_out_5_351_66 : STD_LOGIC; 
  signal ascii_out_5_352_67 : STD_LOGIC; 
  signal ascii_out_5_68 : STD_LOGIC; 
  signal ascii_out_5_681_69 : STD_LOGIC; 
  signal ascii_out_6_111 : STD_LOGIC; 
  signal ascii_out_6_18_72 : STD_LOGIC; 
  signal ascii_out_6_53_73 : STD_LOGIC; 
  signal ascii_out_7_46 : STD_LOGIC; 
  signal ascii_out_7_461_76 : STD_LOGIC; 
  signal ascii_out_7_63 : STD_LOGIC; 
  signal ascii_out_7_631_78 : STD_LOGIC; 
  signal ascii_out_0_OBUF_79 : STD_LOGIC; 
  signal ascii_out_1_OBUF_80 : STD_LOGIC; 
  signal ascii_out_2_OBUF_81 : STD_LOGIC; 
  signal ascii_out_3_OBUF_82 : STD_LOGIC; 
  signal ascii_out_4_OBUF_83 : STD_LOGIC; 
  signal ascii_out_5_OBUF_84 : STD_LOGIC; 
  signal ascii_out_6_OBUF_85 : STD_LOGIC; 
  signal ascii_out_7_OBUF_86 : STD_LOGIC; 
  signal scancode_in_0_IBUF_95 : STD_LOGIC; 
  signal scancode_in_1_IBUF_96 : STD_LOGIC; 
  signal scancode_in_2_IBUF_97 : STD_LOGIC; 
  signal scancode_in_3_IBUF_98 : STD_LOGIC; 
  signal scancode_in_4_IBUF_99 : STD_LOGIC; 
  signal scancode_in_5_IBUF_100 : STD_LOGIC; 
  signal scancode_in_6_IBUF_101 : STD_LOGIC; 
  signal scancode_in_7_IBUF_102 : STD_LOGIC; 
begin
  ascii_out_6_7 : LUT2
    generic map(
      INIT => X"1"
    )
    port map (
      I0 => scancode_in_5_IBUF_100,
      I1 => scancode_in_6_IBUF_101,
      O => ascii_out_0_6
    );
  ascii_out_6_18 : LUT4
    generic map(
      INIT => X"3133"
    )
    port map (
      I0 => scancode_in_0_IBUF_95,
      I1 => scancode_in_1_IBUF_96,
      I2 => ascii_out_0_6,
      I3 => scancode_in_2_IBUF_97,
      O => ascii_out_6_18_72
    );
  ascii_out_6_122 : LUT4
    generic map(
      INIT => X"FFFE"
    )
    port map (
      I0 => N5,
      I1 => ascii_out_6_18_72,
      I2 => ascii_out_6_53_73,
      I3 => ascii_out_6_111,
      O => ascii_out_6_OBUF_85
    );
  ascii_out_4_12 : LUT4
    generic map(
      INIT => X"0103"
    )
    port map (
      I0 => scancode_in_2_IBUF_97,
      I1 => scancode_in_6_IBUF_101,
      I2 => scancode_in_5_IBUF_100,
      I3 => scancode_in_3_IBUF_98,
      O => ascii_out_4_12_59
    );
  ascii_out_4_56 : LUT3
    generic map(
      INIT => X"EF"
    )
    port map (
      I0 => scancode_in_6_IBUF_101,
      I1 => scancode_in_3_IBUF_98,
      I2 => scancode_in_0_IBUF_95,
      O => ascii_out_4_56_61
    );
  ascii_out_6_19 : LUT4
    generic map(
      INIT => X"FFA9"
    )
    port map (
      I0 => scancode_in_6_IBUF_101,
      I1 => scancode_in_4_IBUF_99,
      I2 => scancode_in_5_IBUF_100,
      I3 => scancode_in_7_IBUF_102,
      O => N5
    );
  ascii_out_5_2_SW0 : LUT4
    generic map(
      INIT => X"0203"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_2_IBUF_97,
      I2 => scancode_in_1_IBUF_96,
      I3 => scancode_in_0_IBUF_95,
      O => N37
    );
  ascii_out_5_2_SW1 : LUT4
    generic map(
      INIT => X"222F"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_2_IBUF_97,
      I3 => scancode_in_1_IBUF_96,
      O => N38
    );
  ascii_out_5_2 : LUT4
    generic map(
      INIT => X"FFD8"
    )
    port map (
      I0 => scancode_in_6_IBUF_101,
      I1 => N38,
      I2 => N37,
      I3 => N4,
      O => N6
    );
  ascii_out_5_211 : LUT2
    generic map(
      INIT => X"8"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_4_IBUF_99,
      O => ascii_out_5_21
    );
  ascii_out_3_84 : LUT3
    generic map(
      INIT => X"AB"
    )
    port map (
      I0 => scancode_in_6_IBUF_101,
      I1 => scancode_in_3_IBUF_98,
      I2 => scancode_in_5_IBUF_100,
      O => ascii_out_3_84_57
    );
  ascii_out_3_160 : LUT4
    generic map(
      INIT => X"FFFE"
    )
    port map (
      I0 => N5,
      I1 => ascii_out_3_18,
      I2 => ascii_out_3_68_54,
      I3 => ascii_out_3_131_50,
      O => ascii_out_3_OBUF_82
    );
  ascii_out_1_8 : LUT4
    generic map(
      INIT => X"1110"
    )
    port map (
      I0 => scancode_in_4_IBUF_99,
      I1 => scancode_in_6_IBUF_101,
      I2 => scancode_in_0_IBUF_95,
      I3 => scancode_in_3_IBUF_98,
      O => ascii_out_1_8_38
    );
  ascii_out_1_29 : LUT4
    generic map(
      INIT => X"F2F3"
    )
    port map (
      I0 => ascii_out_1_8_38,
      I1 => scancode_in_2_IBUF_97,
      I2 => N4,
      I3 => scancode_in_1_IBUF_96,
      O => ascii_out_1_29_34
    );
  ascii_out_1_48 : LUT4
    generic map(
      INIT => X"11B1"
    )
    port map (
      I0 => scancode_in_5_IBUF_100,
      I1 => scancode_in_2_IBUF_97,
      I2 => scancode_in_4_IBUF_99,
      I3 => scancode_in_3_IBUF_98,
      O => ascii_out_1_48_35
    );
  ascii_out_1_61 : LUT4
    generic map(
      INIT => X"5501"
    )
    port map (
      I0 => scancode_in_1_IBUF_96,
      I1 => scancode_in_5_IBUF_100,
      I2 => scancode_in_3_IBUF_98,
      I3 => scancode_in_6_IBUF_101,
      O => ascii_out_1_61_36
    );
  ascii_out_1_77 : LUT3
    generic map(
      INIT => X"54"
    )
    port map (
      I0 => scancode_in_0_IBUF_95,
      I1 => ascii_out_1_61_36,
      I2 => ascii_out_1_48_35,
      O => ascii_out_1_77_37
    );
  ascii_out_1_123 : LUT4
    generic map(
      INIT => X"FFE6"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_5_IBUF_100,
      I2 => scancode_in_4_IBUF_99,
      I3 => scancode_in_0_IBUF_95,
      O => ascii_out_1_123_31
    );
  ascii_out_1_137 : LUT3
    generic map(
      INIT => X"20"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_6_IBUF_101,
      I2 => scancode_in_0_IBUF_95,
      O => ascii_out_1_137_32
    );
  ascii_out_1_152 : LUT4
    generic map(
      INIT => X"A888"
    )
    port map (
      I0 => scancode_in_2_IBUF_97,
      I1 => ascii_out_1_137_32,
      I2 => scancode_in_1_IBUF_96,
      I3 => ascii_out_1_123_31,
      O => ascii_out_1_152_33
    );
  ascii_out_1_164 : LUT3
    generic map(
      INIT => X"FE"
    )
    port map (
      I0 => ascii_out_1_29_34,
      I1 => ascii_out_1_77_37,
      I2 => ascii_out_1_152_33,
      O => ascii_out_1_OBUF_80
    );
  ascii_out_0_15 : LUT4
    generic map(
      INIT => X"FF8C"
    )
    port map (
      I0 => scancode_in_0_IBUF_95,
      I1 => ascii_out_0_6,
      I2 => scancode_in_3_IBUF_98,
      I3 => N5,
      O => ascii_out_0_15_24
    );
  ascii_out_0_159 : LUT4
    generic map(
      INIT => X"FFFE"
    )
    port map (
      I0 => ascii_out_0_15_24,
      I1 => ascii_out_0_35_25,
      I2 => ascii_out_0_74,
      I3 => ascii_out_0_128,
      O => ascii_out_0_OBUF_79
    );
  scancode_in_7_IBUF : IBUF
    port map (
      I => scancode_in(7),
      O => scancode_in_7_IBUF_102
    );
  scancode_in_6_IBUF : IBUF
    port map (
      I => scancode_in(6),
      O => scancode_in_6_IBUF_101
    );
  scancode_in_5_IBUF : IBUF
    port map (
      I => scancode_in(5),
      O => scancode_in_5_IBUF_100
    );
  scancode_in_4_IBUF : IBUF
    port map (
      I => scancode_in(4),
      O => scancode_in_4_IBUF_99
    );
  scancode_in_3_IBUF : IBUF
    port map (
      I => scancode_in(3),
      O => scancode_in_3_IBUF_98
    );
  scancode_in_2_IBUF : IBUF
    port map (
      I => scancode_in(2),
      O => scancode_in_2_IBUF_97
    );
  scancode_in_1_IBUF : IBUF
    port map (
      I => scancode_in(1),
      O => scancode_in_1_IBUF_96
    );
  scancode_in_0_IBUF : IBUF
    port map (
      I => scancode_in(0),
      O => scancode_in_0_IBUF_95
    );
  ascii_out_7_OBUF : OBUF
    port map (
      I => ascii_out_7_OBUF_86,
      O => ascii_out(7)
    );
  ascii_out_6_OBUF : OBUF
    port map (
      I => ascii_out_6_OBUF_85,
      O => ascii_out(6)
    );
  ascii_out_5_OBUF : OBUF
    port map (
      I => ascii_out_5_OBUF_84,
      O => ascii_out(5)
    );
  ascii_out_4_OBUF : OBUF
    port map (
      I => ascii_out_4_OBUF_83,
      O => ascii_out(4)
    );
  ascii_out_3_OBUF : OBUF
    port map (
      I => ascii_out_3_OBUF_82,
      O => ascii_out(3)
    );
  ascii_out_2_OBUF : OBUF
    port map (
      I => ascii_out_2_OBUF_81,
      O => ascii_out(2)
    );
  ascii_out_1_OBUF : OBUF
    port map (
      I => ascii_out_1_OBUF_80,
      O => ascii_out(1)
    );
  ascii_out_0_OBUF : OBUF
    port map (
      I => ascii_out_0_OBUF_79,
      O => ascii_out(0)
    );
  ascii_out_6_53_SW0 : LUT4
    generic map(
      INIT => X"FAC8"
    )
    port map (
      I0 => scancode_in_0_IBUF_95,
      I1 => scancode_in_1_IBUF_96,
      I2 => scancode_in_5_IBUF_100,
      I3 => scancode_in_6_IBUF_101,
      O => N40
    );
  ascii_out_6_53 : LUT4
    generic map(
      INIT => X"0222"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_4_IBUF_99,
      I2 => scancode_in_2_IBUF_97,
      I3 => N40,
      O => ascii_out_6_53_73
    );
  ascii_out_3_131_SW0 : LUT4
    generic map(
      INIT => X"09EF"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_4_IBUF_99,
      I2 => scancode_in_0_IBUF_95,
      I3 => scancode_in_1_IBUF_96,
      O => N42
    );
  ascii_out_3_131 : LUT3
    generic map(
      INIT => X"54"
    )
    port map (
      I0 => scancode_in_2_IBUF_97,
      I1 => ascii_out_3_84_57,
      I2 => N42,
      O => ascii_out_3_131_50
    );
  ascii_out_4_94_SW0 : LUT4
    generic map(
      INIT => X"EE4C"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_6_IBUF_101,
      I3 => scancode_in_5_IBUF_100,
      O => N46
    );
  ascii_out_4_38_SW0 : LUT4
    generic map(
      INIT => X"5501"
    )
    port map (
      I0 => scancode_in_4_IBUF_99,
      I1 => scancode_in_2_IBUF_97,
      I2 => scancode_in_6_IBUF_101,
      I3 => scancode_in_3_IBUF_98,
      O => N50
    );
  ascii_out_4_38 : LUT4
    generic map(
      INIT => X"EEFE"
    )
    port map (
      I0 => scancode_in_7_IBUF_102,
      I1 => ascii_out_4_12_59,
      I2 => N50,
      I3 => scancode_in_0_IBUF_95,
      O => ascii_out_4_38_60
    );
  ascii_out_4_69_SW0 : LUT3
    generic map(
      INIT => X"A8"
    )
    port map (
      I0 => scancode_in_6_IBUF_101,
      I1 => scancode_in_4_IBUF_99,
      I2 => scancode_in_5_IBUF_100,
      O => N52
    );
  ascii_out_7_16_SW0 : LUT3
    generic map(
      INIT => X"80"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_4_IBUF_99,
      I2 => scancode_in_5_IBUF_100,
      O => N56
    );
  ascii_out_2_2_SW1 : LUT4
    generic map(
      INIT => X"999D"
    )
    port map (
      I0 => scancode_in_6_IBUF_101,
      I1 => scancode_in_4_IBUF_99,
      I2 => scancode_in_2_IBUF_97,
      I3 => scancode_in_3_IBUF_98,
      O => N58
    );
  ascii_out_2_2 : LUT4
    generic map(
      INIT => X"FFD8"
    )
    port map (
      I0 => scancode_in_5_IBUF_100,
      I1 => scancode_in_6_IBUF_101,
      I2 => N58,
      I3 => scancode_in_7_IBUF_102,
      O => N4
    );
  ascii_out_5_16_SW0 : LUT3
    generic map(
      INIT => X"01"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_5_IBUF_100,
      I2 => scancode_in_6_IBUF_101,
      O => N62
    );
  ascii_out_5_16 : LUT4
    generic map(
      INIT => X"F444"
    )
    port map (
      I0 => scancode_in_0_IBUF_95,
      I1 => N62,
      I2 => scancode_in_2_IBUF_97,
      I3 => scancode_in_1_IBUF_96,
      O => ascii_out_5_16_63
    );
  ascii_out_3_68 : LUT4
    generic map(
      INIT => X"A888"
    )
    port map (
      I0 => scancode_in_0_IBUF_95,
      I1 => N64,
      I2 => scancode_in_1_IBUF_96,
      I3 => scancode_in_2_IBUF_97,
      O => ascii_out_3_68_54
    );
  ascii_out_0_35 : LUT4
    generic map(
      INIT => X"5504"
    )
    port map (
      I0 => scancode_in_0_IBUF_95,
      I1 => N56,
      I2 => scancode_in_2_IBUF_97,
      I3 => scancode_in_6_IBUF_101,
      O => ascii_out_0_35_25
    );
  ascii_out_4_112_SW0 : LUT4
    generic map(
      INIT => X"ADA8"
    )
    port map (
      I0 => scancode_in_2_IBUF_97,
      I1 => N46,
      I2 => scancode_in_1_IBUF_96,
      I3 => ascii_out_4_56_61,
      O => N68
    );
  ascii_out_4_112 : LUT3
    generic map(
      INIT => X"FE"
    )
    port map (
      I0 => N52,
      I1 => ascii_out_4_38_60,
      I2 => N68,
      O => ascii_out_4_OBUF_83
    );
  ascii_out_6_1111 : MUXF5
    port map (
      I0 => N70,
      I1 => N71,
      S => scancode_in_2_IBUF_97,
      O => ascii_out_6_111
    );
  ascii_out_6_1111_F : LUT4
    generic map(
      INIT => X"7577"
    )
    port map (
      I0 => scancode_in_0_IBUF_95,
      I1 => scancode_in_3_IBUF_98,
      I2 => scancode_in_4_IBUF_99,
      I3 => scancode_in_5_IBUF_100,
      O => N70
    );
  ascii_out_6_1111_G : LUT4
    generic map(
      INIT => X"F020"
    )
    port map (
      I0 => scancode_in_4_IBUF_99,
      I1 => scancode_in_3_IBUF_98,
      I2 => scancode_in_0_IBUF_95,
      I3 => scancode_in_1_IBUF_96,
      O => N71
    );
  ascii_out_2_61 : MUXF5
    port map (
      I0 => N72,
      I1 => N73,
      S => scancode_in_5_IBUF_100,
      O => ascii_out_2_61_48
    );
  ascii_out_2_61_F : LUT4
    generic map(
      INIT => X"2A88"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_2_IBUF_97,
      I3 => scancode_in_6_IBUF_101,
      O => N72
    );
  ascii_out_2_61_G : LUT4
    generic map(
      INIT => X"A2AA"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_4_IBUF_99,
      I3 => scancode_in_2_IBUF_97,
      O => N73
    );
  XST_GND : GND
    port map (
      G => N75
    );
  ascii_out_7_461 : LUT4
    generic map(
      INIT => X"0009"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_5_IBUF_100,
      I3 => scancode_in_1_IBUF_96,
      O => ascii_out_7_461_76
    );
  ascii_out_7_46_f5 : MUXF5
    port map (
      I0 => ascii_out_7_461_76,
      I1 => N75,
      S => scancode_in_6_IBUF_101,
      O => ascii_out_7_46
    );
  ascii_out_7_631 : LUT4
    generic map(
      INIT => X"FEEE"
    )
    port map (
      I0 => N6,
      I1 => ascii_out_7_46,
      I2 => scancode_in_0_IBUF_95,
      I3 => scancode_in_1_IBUF_96,
      O => ascii_out_7_63
    );
  ascii_out_7_632 : LUT4
    generic map(
      INIT => X"FEEE"
    )
    port map (
      I0 => N6,
      I1 => ascii_out_7_46,
      I2 => scancode_in_0_IBUF_95,
      I3 => N56,
      O => ascii_out_7_631_78
    );
  ascii_out_7_63_f5 : MUXF5
    port map (
      I0 => ascii_out_7_631_78,
      I1 => ascii_out_7_63,
      S => scancode_in_2_IBUF_97,
      O => ascii_out_7_OBUF_86
    );
  ascii_out_5_351 : LUT3
    generic map(
      INIT => X"10"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_4_IBUF_99,
      I2 => scancode_in_2_IBUF_97,
      O => ascii_out_5_351_66
    );
  ascii_out_5_352 : LUT4
    generic map(
      INIT => X"1110"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_4_IBUF_99,
      I2 => scancode_in_1_IBUF_96,
      I3 => scancode_in_2_IBUF_97,
      O => ascii_out_5_352_67
    );
  ascii_out_5_35_f5 : MUXF5
    port map (
      I0 => ascii_out_5_352_67,
      I1 => ascii_out_5_351_66,
      S => scancode_in_6_IBUF_101,
      O => ascii_out_5_35
    );
  ascii_out_5_681 : LUT4
    generic map(
      INIT => X"FFFE"
    )
    port map (
      I0 => N6,
      I1 => ascii_out_5_21,
      I2 => ascii_out_5_16_63,
      I3 => ascii_out_5_35,
      O => ascii_out_5_68
    );
  ascii_out_5_682 : LUT2
    generic map(
      INIT => X"E"
    )
    port map (
      I0 => N6,
      I1 => ascii_out_5_16_63,
      O => ascii_out_5_681_69
    );
  ascii_out_5_68_f5 : MUXF5
    port map (
      I0 => ascii_out_5_681_69,
      I1 => ascii_out_5_68,
      S => scancode_in_0_IBUF_95,
      O => ascii_out_5_OBUF_84
    );
  ascii_out_2_151 : LUT4
    generic map(
      INIT => X"A820"
    )
    port map (
      I0 => scancode_in_2_IBUF_97,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_4_IBUF_99,
      I3 => scancode_in_1_IBUF_96,
      O => ascii_out_2_151_46
    );
  ascii_out_2_152 : LUT3
    generic map(
      INIT => X"80"
    )
    port map (
      I0 => scancode_in_2_IBUF_97,
      I1 => scancode_in_1_IBUF_96,
      I2 => scancode_in_0_IBUF_95,
      O => ascii_out_2_152_47
    );
  ascii_out_2_15_f5 : MUXF5
    port map (
      I0 => ascii_out_2_152_47,
      I1 => ascii_out_2_151_46,
      S => scancode_in_5_IBUF_100,
      O => ascii_out_2_15
    );
  ascii_out_2_1101 : LUT3
    generic map(
      INIT => X"1F"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_2_IBUF_97,
      O => ascii_out_2_1101_41
    );
  ascii_out_2_1102 : LUT4
    generic map(
      INIT => X"262F"
    )
    port map (
      I0 => scancode_in_4_IBUF_99,
      I1 => scancode_in_2_IBUF_97,
      I2 => scancode_in_3_IBUF_98,
      I3 => scancode_in_0_IBUF_95,
      O => ascii_out_2_1102_42
    );
  ascii_out_2_110_f5 : MUXF5
    port map (
      I0 => ascii_out_2_1102_42,
      I1 => ascii_out_2_1101_41,
      S => scancode_in_6_IBUF_101,
      O => ascii_out_2_110
    );
  ascii_out_2_1251 : LUT3
    generic map(
      INIT => X"FE"
    )
    port map (
      I0 => N4,
      I1 => ascii_out_2_15,
      I2 => ascii_out_2_61_48,
      O => ascii_out_2_125
    );
  ascii_out_2_1252 : LUT4
    generic map(
      INIT => X"FFFE"
    )
    port map (
      I0 => ascii_out_2_110,
      I1 => N4,
      I2 => ascii_out_2_15,
      I3 => ascii_out_2_61_48,
      O => ascii_out_2_1251_44
    );
  ascii_out_2_125_f5 : MUXF5
    port map (
      I0 => ascii_out_2_1251_44,
      I1 => ascii_out_2_125,
      S => scancode_in_1_IBUF_96,
      O => ascii_out_2_OBUF_81
    );
  ascii_out_0_1281 : LUT4
    generic map(
      INIT => X"1551"
    )
    port map (
      I0 => scancode_in_1_IBUF_96,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_3_IBUF_98,
      I3 => scancode_in_2_IBUF_97,
      O => ascii_out_0_1281_22
    );
  ascii_out_0_1282 : LUT4
    generic map(
      INIT => X"0155"
    )
    port map (
      I0 => scancode_in_1_IBUF_96,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_3_IBUF_98,
      I3 => scancode_in_2_IBUF_97,
      O => ascii_out_0_1282_23
    );
  ascii_out_0_128_f5 : MUXF5
    port map (
      I0 => ascii_out_0_1282_23,
      I1 => ascii_out_0_1281_22,
      S => scancode_in_4_IBUF_99,
      O => ascii_out_0_128
    );
  ascii_out_0_741 : LUT4
    generic map(
      INIT => X"C040"
    )
    port map (
      I0 => scancode_in_4_IBUF_99,
      I1 => scancode_in_2_IBUF_97,
      I2 => scancode_in_1_IBUF_96,
      I3 => scancode_in_0_IBUF_95,
      O => ascii_out_0_741_28
    );
  ascii_out_0_742 : LUT4
    generic map(
      INIT => X"D580"
    )
    port map (
      I0 => scancode_in_2_IBUF_97,
      I1 => scancode_in_0_IBUF_95,
      I2 => scancode_in_1_IBUF_96,
      I3 => scancode_in_6_IBUF_101,
      O => ascii_out_0_742_29
    );
  ascii_out_0_74_f5 : MUXF5
    port map (
      I0 => ascii_out_0_742_29,
      I1 => ascii_out_0_741_28,
      S => scancode_in_3_IBUF_98,
      O => ascii_out_0_74
    );
  ascii_out_3_182 : LUT4
    generic map(
      INIT => X"0001"
    )
    port map (
      I0 => scancode_in_0_IBUF_95,
      I1 => scancode_in_3_IBUF_98,
      I2 => scancode_in_5_IBUF_100,
      I3 => scancode_in_1_IBUF_96,
      O => ascii_out_3_182_53
    );
  ascii_out_3_18_f5 : MUXF5
    port map (
      I0 => ascii_out_3_182_53,
      I1 => ascii_out_3_181,
      S => scancode_in_6_IBUF_101,
      O => ascii_out_3_18
    );
  ascii_out_3_68_SW01 : LUT3
    generic map(
      INIT => X"20"
    )
    port map (
      I0 => scancode_in_4_IBUF_99,
      I1 => scancode_in_3_IBUF_98,
      I2 => scancode_in_5_IBUF_100,
      O => ascii_out_3_68_SW0
    );
  ascii_out_3_68_SW02 : LUT4
    generic map(
      INIT => X"4062"
    )
    port map (
      I0 => scancode_in_3_IBUF_98,
      I1 => scancode_in_5_IBUF_100,
      I2 => scancode_in_4_IBUF_99,
      I3 => scancode_in_1_IBUF_96,
      O => ascii_out_3_68_SW01_56
    );
  ascii_out_3_68_SW0_f5 : MUXF5
    port map (
      I0 => ascii_out_3_68_SW01_56,
      I1 => ascii_out_3_68_SW0,
      S => scancode_in_6_IBUF_101,
      O => N64
    );
  ascii_out_3_181_INV_0 : INV
    port map (
      I => scancode_in_0_IBUF_95,
      O => ascii_out_3_181
    );

end Structure;

