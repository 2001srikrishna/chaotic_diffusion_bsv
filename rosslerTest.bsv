package rosslerTest;
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
    
    
    function Arr_3d rossler_diffusion(Arr_3d ros_in);
            Arr_16 ros_in_r = tpl_1(ros_in);
            Arr_16 ros_in_g = tpl_2(ros_in);
            Arr_16 ros_in_b = tpl_3(ros_in);

            Arr_16 ros_out_r = replicate(replicate(0));
            Arr_16 ros_out_g = replicate(replicate(0));
            Arr_16 ros_out_b = replicate(replicate(0));

            Float a = unpack(32'h41200000); // 0.2 
            Float b = unpack(32'h402aaaab); // 0.2
            Float c = unpack(32'h41e00000); // 5.7
            Float dt = unpack(32'h3a83126f);// 0.001

            Vector#(Two_d,Float) x;
            Vector#(Two_d,Float) y;
            Vector#(Two_d,Float) z;

            x[0] = unpack(32'hbf800000); // -1
            y[0] = unpack(32'h3dcccccd); // 0.1
            z[0] = unpack(32'h41c80000); // 25

            Integer i;
            Integer j;

            for(i=0;i<valueof(Two_d)-1;i=i+1)
            begin
                x[i+1]=x[i]+dt*(-y[i]-z[i]);
                y[i+1]=y[i]+dt*(x[i+1]+a*y[i]);
                z[i+1]=z[i]+dt*(b+z[i]*(x[i+1]-c));
            end

            Vector#(Two_d,(One_byte)) x_reg;
            Vector#(Two_d,(One_byte)) y_reg;
            Vector#(Two_d,(One_byte)) z_reg;

            Float prec_fact = unpack(32'h47c35000); //1E+5
            Int#(64) v;
            //Integer tmp;
            for(i=0;i<valueof(Two_d);i=i+1)
            begin
                v = tpl_1((vFloatToFixed(6'd0,x[i]*prec_fact,Rnd_Zero)));
                x_reg[i] = pack(v)[7:0];

                v = tpl_1((vFloatToFixed(6'd0,y[i]*prec_fact,Rnd_Zero)));
                y_reg[i] = pack(v)[7:0];

                v = tpl_1((vFloatToFixed(6'd0,z[i]*prec_fact,Rnd_Zero)));
                z_reg[i] = pack(v)[7:0];
            end

            Arr_16 x_2d = replicate(replicate(0));
            Arr_16 y_2d = replicate(replicate(0));
            Arr_16 z_2d = replicate(replicate(0));

            for(i=0;i<valueof(Width);i=i+1)
            begin
                for(j=0;j<valueof(Height);j=j+1)
                begin
                    x_2d[i][j] = x_reg[valueof(Width)*i+j];
                    y_2d[i][j] = y_reg[valueof(Width)*i+j];
                    z_2d[i][j] = z_reg[valueof(Width)*i+j];
                end
            end


            //mandal2013

                

            for(i=0;i<valueof(Width);i=i+1)
            begin
                for(j=0;j<valueof(Height);j=j+1)
                begin
                    
                    ros_out_r[i][j] = x_2d[i][j]^ros_in_r[i][j];
                    ros_out_g[i][j] = y_2d[i][j]^ros_in_g[i][j];
                    ros_out_b[i][j] = z_2d[i][j]^ros_in_b[i][j];

                end
            end

                Arr_3d ros_out = tuple3(ros_out_r,ros_out_g,ros_out_b);

                return ros_out;

        endfunction

    interface Wrapper_3d;
            method Action byte_in(Bit#(TLog#(Two_d)) idx1,Bit#(TLog#(Two_d)) idx2,Bit#(TLog#(Two_d)) idx3, One_byte data1, One_byte data2, One_byte data3);
            method Tuple3#(One_byte,One_byte,One_byte) byte_out(Bit#(TLog#(Two_d)) idx1,Bit#(TLog#(Two_d)) idx2,Bit#(TLog#(Two_d)) idx3);
    endinterface


(* synthesize *)
module mkRossTest(Wrapper_3d);

    Reg#(Arr_16) burst_in_r <- mkRegU;
    Reg#(Arr_16) burst_in_g <- mkRegU;
    Reg#(Arr_16) burst_in_b <- mkRegU;

    Arr_3d burst_out = rossler_diffusion(tuple3(burst_in_r,burst_in_g,burst_in_b));
    

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
