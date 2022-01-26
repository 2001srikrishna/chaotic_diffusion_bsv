package bigSpiralTest;

    import Vector::*;
    import FShow :: *;
    import FloatingPoint :: *;
    import StmtFSM::*;
    import List ::*;
    import BuildVector::*;
    import Semi_FIFOF::*;
    import FIFOF::*;
    import AXI4_Types::*;
    import BUtils::*;
    
    typedef 16 Width ;
    typedef 16 Height ;
    typedef 3 Dim ;
    typedef 0 Null;

    typedef 8 Eight;

    typedef TMul#(TMul#(Width,Height),Dim) SizeOfLengthReal ;
    typedef TDiv#(SizeOfLengthReal,Dim) Two_d ;


    typedef Bit#(8) One_byte;
    typedef Vector#(Width,Vector#(Height,(One_byte))) Arr_16;
    typedef Vector#(Width,Vector#(Height,Reg#(One_byte))) Arr_16_Reg;
    typedef Vector#(8,Vector#(8,(One_byte))) Arr_8;
    typedef Vector#(Two_d,(One_byte)) Arr_1d;

    typedef Tuple3#(Arr_16,Arr_16,Arr_16) Arr_3d;
    typedef Tuple3#(Vector#(Two_d,One_byte),Vector#(Two_d,One_byte),Vector#(Two_d,One_byte)) Three_2d;
    typedef Tuple2#(Arr_3d,Three_2d) Lor_to_rc5;

    
    function Arr_16 bigspiral(Arr_16 ss_in);

                Arr_16 ss_out = replicate(replicate(0));

                Integer i = 0; 
                
    
              Vector#(256,Integer)idx = vec(135,136,120,119,118,134,150,151,152,153,137,121,105,104,103,
              102,101,117,133,149,165,166,167,168,169,170,154,138,122,106,90,89,88,87,86,85,84,100,116,
              132,148,164,180,181,182,183,184,185,186,187,171,155,139,123,107,91,75,74,73,72,71,70,69,
              68,67,83,99,115,131,147,163,179,195,196,197,198,199,200,201,202,203,204,188,172,156,140,
              124,108,92,76,60,59,58,57,56,55,54,53,52,51,50,66,82,98,114,130,146,162,178,194,210,211,
              212,213,214,215,216,217,218,219,220,221,205,189,173,157,141,125,109,93,77,61,45,44,43,42,
              41,40,39,38,37,36,35,34,33,49,65,81,97,113,129,145,161,177,193,209,225,226,227,228,229,230,
              231,232,233,234,235,236,237,238,222,206,190,174,158,142,126,110,94,78,62,46,30,29,28,27,
              26,25,24,23,22,21,20,19,18,17,16,32,48,64,80,96,112,128,144,160,176,192,208,224,240,241,
              242,243,244,245,246,247,248,249,250,251,252,253,254,255,239,223,207,191,175,159,143,127,
              111,95,79,63,47,31,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1,0);


        
            for(i=0;i<valueof(Two_d);i=i+1)
            begin
                ss_out[i/valueOf(Width)][i%valueOf(Height)] = ss_in[idx[i]/valueOf(Width)][idx[i]%valueOf(Height)];
            end 
          
                return ss_out;

    endfunction

interface Wrapper;
            method Action byte_in(Bit#(TLog#(Two_d)) idx, One_byte data);
            method One_byte byte_out(Bit#(TLog#(Two_d)) idx);
    endinterface

(* synthesize *)
module mkbigburst(Wrapper);

    Reg#(Arr_16) burst_in <- mkRegU;
    Arr_16 burst_out = bigspiral(burst_in);

    method Action byte_in(Bit#(TLog#(Two_d)) idx, One_byte data);
        burst_in[idx/16][idx%16] <= data;
    endmethod

    method One_byte byte_out(Bit#(TLog#(Two_d)) idx);
        return burst_out[idx/16][idx%16];
    endmethod   

endmodule 

endpackage