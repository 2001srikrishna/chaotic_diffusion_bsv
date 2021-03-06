package lorentzTest;
    import Vector::*;
    import FShow :: *;
    import FloatingPoint :: *;
    import StmtFSM::*;
    import List ::*;
    import BuildVector ::*;
    
    typedef 16 Width ;
    typedef 16 Height ;
    typedef 3 Dim ;
    

    typedef TMul#(TMul#(Width,Height),Dim) SizeOfLengthReal ;
    typedef TMul#(Width,Height) Two_d ;


    typedef Bit#(8) One_byte;
    typedef Vector#(Width,Vector#(Height,(One_byte))) Arr_16;
    
    typedef Tuple3#(Arr_16,Arr_16,Arr_16) Arr_3d;
    typedef Tuple3#(Vector#(Two_d,One_byte),Vector#(Two_d,One_byte),Vector#(Two_d,One_byte)) Three_2d;
    typedef Tuple2#(Arr_3d,Three_2d) Lor_to_rc5;
    typedef Vector#(Dim,Vector#(Two_d,Bit#(TLog#(Two_d)))) Lor_idx_type;
    
    interface Ifc_io;

        method ActionValue#(Arr_3d) io(Arr_3d a);

    endinterface
    
    function Arr_3d lorentz_confusion(Arr_3d lor_in);


            Arr_16 lor_in_r = tpl_1(lor_in);
            Arr_16 lor_in_g = tpl_2(lor_in);
            Arr_16 lor_in_b = tpl_3(lor_in);
            

            Arr_16 lor_out_r = replicate(replicate(0));
            Arr_16 lor_out_g = replicate(replicate(0));
            Arr_16 lor_out_b = replicate(replicate(0));            
            Integer i;
            
            Vector#(Two_d,Integer)idx_r = vec(57,58,56,59,55,60,54,61,53,62,52,51,63,50,64,49,65,48,47,66,46,45,67,44,43,68,42,41,
            69,40,39,38,70,37,36,35,34,71,33,32,31,30,29,28,72,27,26,25,24,23,22,21,20,19,18,17,73,16,15,
            14,13,12,11,10,74,9,8,7,75,6,76,5,77,4,78,3,79,80,81,2,82,83,84,85,86,1,87,88,89,90,91,206,205,
            207,204,208,203,209,202,210,201,144,145,143,92,146,142,211,200,147,141,148,140,212,199,149,139,
            213,93,150,198,138,151,214,137,197,152,94,136,215,196,153,135,256,216,95,195,154,134,217,255,155,
            194,96,133,218,156,254,193,132,97,157,219,192,131,253,98,158,220,130,191,252,159,99,221,129,190,
            160,251,100,128,222,189,161,101,250,127,223,188,162,102,126,249,224,163,187,103,125,248,225,164,
            186,104,124,226,165,247,105,185,123,166,106,227,122,184,246,107,167,121,228,183,245,108,120,168,
            182,109,229,119,244,169,110,118,181,230,111,117,170,243,112,116,180,113,115,114,171,231,179,242,
            172,178,173,232,177,174,241,176,175,233,240,234,239,235,238,236,237);

            Vector#(Two_d,Integer)idx_g = vec(52,53,51,54,50,55,49,48,56,47,57,46,45,44,58,43,42,59,41,40,39,
            38,60,37,1,36,35,2,34,33,3,61,32,31,4,30,29,5,28,27,6,26,7,25,24,8,23,9,22,21,10,20,11,19,62,18,
            12,17,13,16,14,15,63,64,65,256,255,254,197,196,198,195,199,253,194,200,193,201,252,136,202,135,
            192,137,134,138,133,251,139,203,191,132,140,131,204,141,190,250,130,142,205,66,189,129,143,249,
            206,128,188,144,207,127,248,145,187,208,126,146,247,186,209,147,125,246,185,148,210,124,149,211,
            184,123,245,67,150,212,122,183,244,83,151,84,82,85,81,213,86,80,121,182,87,152,79,243,88,214,78,120,
            89,153,181,77,90,215,68,242,119,154,76,91,180,92,216,75,118,155,241,93,179,74,69,217,117,156,94,73,240,
            178,95,70,218,72,116,157,71,96,239,177,115,158,219,97,114,159,176,98,238,220,113,160,99,175,221,237,100,
            112,161,174,101,111,222,162,236,102,110,173,103,109,163,223,104,108,172,105,235,107,106,164,224,171,165,
            234,170,166,169,225,167,168,233,226,232,227,231,228,230,229);
            
            Vector#(Two_d,Integer)idx_b = vec(27,28,26,29,25,30,24,23,31,22,21,32,20,19,33,18,17,16,34,15,14,13,35,12,
            11,10,36,9,8,7,37,6,5,4,38,3,39,2,1,40,41,42,43,44,45,46,47,48,49,50,51,214,215,213,216,212,217,211,218,210,
            153,152,219,209,154,151,155,150,156,208,149,220,157,148,207,221,147,158,206,146,159,222,93,92,94,91,95,145,
            90,205,160,96,89,223,97,144,88,204,161,98,143,87,224,99,162,203,142,86,100,225,202,163,141,85,101,201,164,
            226,140,102,84,200,139,165,103,227,83,138,199,104,166,228,82,137,52,105,198,167,136,229,106,81,197,168,135,
            107,230,196,169,80,134,108,195,231,133,170,256,109,194,79,132,232,171,110,255,193,131,111,233,172,254,192,130,
            78,112,173,129,191,253,234,113,128,174,190,252,235,114,127,77,189,175,115,126,251,236,116,188,125,176,117,250,
            124,187,237,177,118,123,119,122,120,121,186,249,178,238,185,76,179,248,184,180,183,181,239,182,247,240,246,241,
            245,242,244,243,75,74,53,73,72,71,70,54,69,68,67,55,66,65,56,64,57,63,62,58,61,59,60);
            
            for(i=0;i<valueof(Two_d);i=i+1)
            begin
               
                lor_out_r[i/valueof(Height)][i%valueof(Width)] = lor_in_r[(idx_r[i]-1)/16][(idx_r[i]-1)%16];

                lor_out_g[i/valueof(Height)][i%valueof(Width)] = lor_in_g[(idx_g[i]-1)/16][(idx_g[i]-1)%16];
                
                lor_out_b[i/valueof(Height)][i%valueof(Width)] = lor_in_b[(idx_b[i]-1)/16][(idx_b[i]-1)%16];
            end

            Arr_3d lor_out = tuple3(lor_out_r,lor_out_g,lor_out_b);

            return lor_out;
        endfunction

    interface Wrapper_3d;
            method Action byte_in(Bit#(TLog#(Two_d)) idx1,Bit#(TLog#(Two_d)) idx2,Bit#(TLog#(Two_d)) idx3, One_byte data1, One_byte data2, One_byte data3);
            method Tuple3#(One_byte,One_byte,One_byte) byte_out(Bit#(TLog#(Two_d)) idx1,Bit#(TLog#(Two_d)) idx2,Bit#(TLog#(Two_d)) idx3);
    endinterface


(* synthesize *)
module mkLorTest(Wrapper_3d);

    Reg#(Arr_16) burst_in_r <- mkRegU;
    Reg#(Arr_16) burst_in_g <- mkRegU;
    Reg#(Arr_16) burst_in_b <- mkRegU;

    Arr_3d burst_out = lorentz_confusion(tuple3(burst_in_r,burst_in_g,burst_in_b));
    

    method Action byte_in(Bit#(TLog#(Two_d)) idx1,Bit#(TLog#(Two_d)) idx2,Bit#(TLog#(Two_d)) idx3, One_byte data1, One_byte data2, One_byte data3);
        burst_in_r[idx1/16][idx1%16] <= data1;
        burst_in_g[idx2/16][idx2%16] <= data2;
        burst_in_b[idx3/16][idx3%16] <= data3;
    endmethod

    method Tuple3#(One_byte,One_byte,One_byte) byte_out(Bit#(TLog#(Two_d)) idx1,Bit#(TLog#(Two_d)) idx2,Bit#(TLog#(Two_d)) idx3);
        return tuple3(tpl_1(burst_out)[idx1/16][idx1%16],tpl_2(burst_out)[idx2/16][idx2%16],tpl_3(burst_out)[idx3/16][idx3%16]);
    endmethod   

endmodule
endpackage
