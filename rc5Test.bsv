package rc5Test;
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
    // typedef Tuple2#(Arr_3d,Three_2d) Lor_to_rc5;
    typedef Vector#(Dim,Vector#(Two_d,Bit#(TLog#(Two_d)))) Lor_idx_type;
    
    function One_byte circ_shift(One_byte in_byte,Bit#(3) zm); // right circular shift 

            Bit#(3) i;

            for(i=0;i<zm;i=i+1)
            begin
                in_byte = {in_byte[0],in_byte[7:1]};
            end

            return in_byte;
    endfunction


    function Arr_3d rc5_encryption(Arr_3d rc5_in);

            Arr_16 rc5_in_r = tpl_1(rc5_in);
            Arr_16 rc5_in_g = tpl_2(rc5_in);
            Arr_16 rc5_in_b = tpl_3(rc5_in);

            Vector#(Two_d,One_byte) lor_r = vec(56,57,55,58,54,59,53,60,52,61,51,50,62,49,63,48,64,47,46,65,45,44,66,43,42,67,
            41,40,68,39,38,37,69,36,35,34,33,70,32,31,30,29,28,27,71,26,25,24,23,22,21,20,19,18,17,16,72,15,14,13,12,11,10,9,73,
            8,7,6,74,5,75,4,76,3,77,2,78,79,80,1,81,82,83,84,85,0,86,87,88,89,90,205,204,206,203,207,202,208,201,209,200,143,144,
            142,91,145,141,210,199,146,140,147,139,211,198,148,138,212,92,149,197,137,150,213,136,196,151,93,135,214,195,152,134,255,
            215,94,194,153,133,216,254,193,95,132,217,155,253,192,131,96,156,218,191,130,252,97,157,219,129,190,251,158,98,220,128,
            189,159,250,99,127,221,188,160,100,249,126,222,187,161,101,125,248,223,162,186,102,124,247,224,163,185,103,123,225,164,246,
            104,184,122,165,105,226,121,183,245,106,166,120,227,182,244,107,119,167,181,108,228,118,243,168,109,117,180,229,110,116,169,
            242,111,115,179,112,114,113,170,230,178,241,171,177,172,231,176,173,240,175,174,232,239,233,238,234,237,235,236);

            Vector#(Two_d,One_byte)lor_g = vec(51,52,50,53,49,54,48,47,55,46,56,45,44,43,57,42,41,58,40,39,38,37,59,36,0,35,34,
            1,33,32,2,60,31,30,3,29,28,4,27,26,5,25,6,24,23,7,22,8,21,20,9,19,10,18,61,17,11,16,12,15,13,14,62,63,64,255,254,
            253,196,195,197,194,198,252,193,199,192,200,251,135,201,134,191,136,133,137,132,250,138,202,190,131,139,130,203,140,
            189,249,129,141,204,65,188,128,142,248,205,127,187,143,206,126,247,144,186,207,125,145,246,185,208,146,124,245,184,
            147,209,123,148,210,183,122,244,66,149,211,121,182,243,82,150,83,81,84,80,212,85,79,120,181,86,151,78,242,87,213,77,
            119,88,152,180,76,89,214,67,241,118,153,75,90,179,91,215,74,117,154,240,92,178,73,68,216,116,155,93,72,239,177,94,69,
            217,71,115,156,70,95,238,176,114,157,218,96,113,158,175,97,237,219,112,159,98,174,220,236,99,111,160,173,100,110,221,
            161,235,101,109,172,102,108,162,222,103,107,171,104,234,106,105,163,223,170,164,233,169,165,168,224,166,167,232,225,
            231,226,230,227,229,228);
            
            Vector#(Two_d,One_byte)lor_b = vec(26,27,25,28,24,29,23,22,30,21,20,31,19,18,32,17,16,15,33,14,13,12,34,11,10,9,35,8,7,6,36,5,4,3,37,2,38,1,0,39,40,41,42,43,44,45,46,47,48,49,50,213,214,212,215,211,216,210,217,209,152,151,218,208,153,150,154,149,155,207,148,219,156,147,206,220,146,157,205,145,158,221,92,91,93,90,94,144,89,204,159,95,88,222,96,143,87,203,160,97,142,86,223,98,161,202,141,85,99,224,201,162,140,84,100,200,163,225,139,101,83,199,138,164,102,226,82,137,198,103,165,227,81,136,51,104,197,166,135,228,105,80,196,167,134,106,229,195,168,79,133,107,194,230,132,169,255,108,193,78,131,231,170,109,254,192,130,110,232,171,253,191,129,77,111,172,128,190,252,233,112,127,173,189,251,234,113,126,76,188,174,114,125,250,235,115,187,124,175,116,249,123,186,236,176,117,122,118,121,119,120,185,248,177,237,184,75,178,247,183,179,182,180,238,181,246,239,245,240,244,241,243,242,74,73,52,72,71,70,69,53,68,67,66,54,65,64,55,63,56,62,61,57,60,58,59);

            Vector#(Two_d,Integer) int_lor_r = vec(56,57,55,58,54,59,53,60,52,61,51,50,62,49,63,48,64,47,46,65,45,44,66,43,42,67,
            41,40,68,39,38,37,69,36,35,34,33,70,32,31,30,29,28,27,71,26,25,24,23,22,21,20,19,18,17,16,72,15,14,13,12,11,10,9,73,
            8,7,6,74,5,75,4,76,3,77,2,78,79,80,1,81,82,83,84,85,0,86,87,88,89,90,205,204,206,203,207,202,208,201,209,200,143,144,
            142,91,145,141,210,199,146,140,147,139,211,198,148,138,212,92,149,197,137,150,213,136,196,151,93,135,214,195,152,134,
            255,215,94,194,153,133,216,254,193,95,132,217,155,253,192,131,96,156,218,191,130,252,97,157,219,129,190,251,158,98,
            220,128,189,159,250,99,127,221,188,160,100,249,126,222,187,161,101,125,248,223,162,186,102,124,247,224,163,185,103,
            123,225,164,246,104,184,122,165,105,226,121,183,245,106,166,120,227,182,244,107,119,167,181,108,228,118,243,168,109,
            117,180,229,110,116,169,242,111,115,179,112,114,113,170,230,178,241,171,177,172,231,176,173,240,175,174,232,239,233,
            238,234,237,235,236);

            Vector#(Two_d,Integer) int_lor_g = vec(51,52,50,53,49,54,48,47,55,46,56,45,44,43,57,42,41,58,40,39,38,37,59,36,0,35,
            34,1,33,32,2,60,31,30,3,29,28,4,27,26,5,25,6,24,23,7,22,8,21,20,9,19,10,18,61,17,11,16,12,15,13,14,62,63,64,255,254,
            253,196,195,197,194,198,252,193,199,192,200,251,135,201,134,191,136,133,137,132,250,138,202,190,131,139,130,203,140,
            189,249,129,141,204,65,188,128,142,248,205,127,187,143,206,126,247,144,186,207,125,145,246,185,208,146,124,245,184,
            147,209,123,148,210,183,122,244,66,149,211,121,182,243,82,150,83,81,84,80,212,85,79,120,181,86,151,78,242,87,213,77,
            119,88,152,180,76,89,214,67,241,118,153,75,90,179,91,215,74,117,154,240,92,178,73,68,216,116,155,93,72,239,177,94,69,
            217,71,115,156,70,95,238,176,114,157,218,96,113,158,175,97,237,219,112,159,98,174,220,236,99,111,160,173,100,110,221,
            161,235,101,109,172,102,108,162,222,103,107,171,104,234,106,105,163,223,170,164,233,169,165,168,224,166,167,232,225,
            231,226,230,227,229,228);
            
            Vector#(Two_d,Integer) int_lor_b = vec(26,27,25,28,24,29,23,22,30,21,20,31,19,18,32,17,16,15,33,14,13,12,34,11,10,9,35,8,7,6,36,5,4,3,37,2,38,1,0,39,40,41,42,43,44,45,46,47,48,49,50,213,214,212,215,211,216,210,217,209,152,151,218,208,153,150,154,149,155,207,148,219,156,147,206,220,146,157,205,145,158,221,92,91,93,90,94,144,89,204,159,95,88,222,96,143,87,203,160,97,142,86,223,98,161,202,141,85,99,224,201,162,140,84,100,200,163,225,139,101,83,199,138,164,102,226,82,137,198,103,165,227,81,136,51,104,197,166,135,228,105,80,196,167,134,106,229,195,168,79,133,107,194,230,132,169,255,108,193,78,131,231,170,109,254,192,130,110,232,171,253,191,129,77,111,172,128,190,252,233,112,127,173,189,251,234,113,126,76,188,174,114,125,250,235,115,187,124,175,116,249,123,186,236,176,117,122,118,121,119,120,185,248,177,237,184,75,178,247,183,179,182,180,238,181,246,239,245,240,244,241,243,242,74,73,52,72,71,70,69,53,68,67,66,54,65,64,55,63,56,62,61,57,60,58,59);

            Arr_16 rc5_out_r = replicate(replicate(0));
            Arr_16 rc5_out_g = replicate(replicate(0));
            Arr_16 rc5_out_b = replicate(replicate(0));

            Bit#(3) z_r;
            Bit#(3) z_g;
            Bit#(3) z_b;

            Integer i;
            Integer j;
            
            for(i=0;i<valueof(Width);i=i+1)
            begin
                for(j=0;j<valueof(Height);j=j+1)
                begin
                    z_r = truncate((lor_r[i*valueof(Width)+j])%6 + 1); 
                    rc5_out_r[i][j] = rc5_in_r[i][j]^(lor_r[i*valueof(Width)+j])^(fromInteger((2**(int_lor_r[i*valueof(Width)+j])%255))); 
                    rc5_out_r[i][j] = circ_shift(rc5_out_r[i][j],z_r);

                    z_g = truncate((lor_g[i*valueof(Width)+j])%6 + 1); 
                    rc5_out_g[i][j] = rc5_in_r[i][j]^(lor_g[i*valueof(Width)+j])^(fromInteger((2**(int_lor_g[i*valueof(Width)+j])%255))); 
                    rc5_out_g[i][j] = circ_shift(rc5_out_g[i][j],z_g);

                    z_b = truncate((lor_b[i*valueof(Width)+j])%6 + 1); 
                    rc5_out_b[i][j] = rc5_in_r[i][j]^(lor_b[i*valueof(Width)+j])^(fromInteger((2**(int_lor_b[i*valueof(Width)+j])%255))); 
                    rc5_out_b[i][j] = circ_shift(rc5_out_b[i][j],z_b);
                end
            end

            Arr_3d rc5_out = tuple3(rc5_out_r,rc5_out_g,rc5_out_b);

            return rc5_out;
        endfunction

        interface Wrapper_3d;
            method Action byte_in(Bit#(TLog#(Two_d)) idx1,Bit#(TLog#(Two_d)) idx2,Bit#(TLog#(Two_d)) idx3, One_byte data1, One_byte data2, One_byte data3);
            method Tuple3#(One_byte,One_byte,One_byte) byte_out(Bit#(TLog#(Two_d)) idx1,Bit#(TLog#(Two_d)) idx2,Bit#(TLog#(Two_d)) idx3);
    endinterface


(* synthesize *)
module mkRC5Test(Wrapper_3d);

    Reg#(Arr_16) burst_in_r <- mkRegU;
    Reg#(Arr_16) burst_in_g <- mkRegU;
    Reg#(Arr_16) burst_in_b <- mkRegU;

    Arr_3d burst_out = rc5_encryption(tuple3(burst_in_r,burst_in_g,burst_in_b));
    

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