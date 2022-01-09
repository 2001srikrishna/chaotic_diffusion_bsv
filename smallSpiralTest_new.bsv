package smallSpiralTest_new;

    import Vector::*;
    import FShow :: *;
    import FloatingPoint :: *;
    import StmtFSM::*;
    import List ::*;
    import BuildVector::*;
    import FIFOF::*;
    import AXI4_Types::*;
    
    typedef 16 Width ;
    typedef 16 Height ;
    typedef 3 Dim ;
    typedef 0 Null;

    typedef 8 Eight;

    typedef TMul#(TMul#(Width,Height),Dim) SizeOfLengthReal ;
    typedef TDiv#(SizeOfLengthReal,Dim) Two_d ;


    typedef Bit#(8) One_byte;
    typedef Vector#(Width,Vector#(Height,(One_byte))) Arr_16;
    typedef Vector#(8,Vector#(8,(One_byte))) Arr_8;
    typedef Vector#(Two_d,(One_byte)) Arr_1d;

    typedef Tuple3#(Arr_16,Arr_16,Arr_16) Arr_3d;
    typedef Tuple3#(Vector#(Two_d,One_byte),Vector#(Two_d,One_byte),Vector#(Two_d,One_byte)) Three_2d;
    typedef Tuple2#(Arr_3d,Three_2d) Lor_to_rc5;

    interface Ifc_io;

        method ActionValue#(Arr_16) io (Arr_16 ss_in);

    endinterface
    
    function Arr_8 cut_arr(Arr_16 ss_in,Integer i,Integer j);

            Arr_8 small_arr = replicate(replicate(0));

            Integer wid = 8;
            Integer heit = 8;
                
            Integer k = 0;
            Integer l = 0;

                for(k=0;k<wid;k=k+1)
                begin
                    for(l=0;l<heit;l=l+1)
                    begin
                        small_arr[k][l] = ss_in[i+k][j+l];
                    end
                end
            return small_arr;
    endfunction

    function Arr_16 join_arr(Arr_16 ss_16,Arr_8 ss_8,Integer i,Integer j);

            //Arr_16 temp = replicate(replicate(0));
            Integer wid = 8;
            Integer heit = 8;
            
            Integer k = 0;
            Integer l = 0;

            Arr_1d temp = replicate(0);

            for(k=0;k<valueof(Width);k=k+1)
            begin
                for(l=0;l<valueof(Height);l=l+1)
                begin
                    temp[valueOf(Width)*k+l] = ss_16[k][l];
                end
            end

                    for(k=0;k<wid;k=k+1)
                    begin
                        for(l=0;l<heit;l=l+1)
                        begin
                            temp = update(temp,valueOf(Width)*(i+k)+j+l,ss_8[k][l]);
                        end
                    end

            for(k=0;k<valueof(Width);k=k+1)
            begin
                for(l=0;l<valueof(Height);l=l+1)
                begin
                    ss_16[k][l] = temp[valueOf(Width)*k+l];
                end
            end

            return ss_16;
    endfunction

    function Arr_16 spiral(Arr_16 ss_in);

                Arr_16 ss_out = replicate(replicate(0));
                Arr_8 small_arr = replicate(replicate(0));
                Arr_8 small_temp = replicate(replicate(0));

                Integer wid = 8;
                Integer heit = 8;

                Integer i = 0; 
                Integer j = 0;

                Integer k = wid/2-1;    
                Integer l = heit/2-1;

                Integer x = 0;
                Integer y = 0;

                Integer ht = wid/2;
                Integer bt = heit/2;
    
              Vector#(64,Integer)idx = vec(27,28,36,35,34,26,18,19,20,21,29,37,45,44,43,42,41,33,25,17,9,10,11,12,13,14,22,
              30,38,46,54,53,52,51,50,49,48,40,32,24,16,8,0,1,2,3,4,5,6,7,15,23,31,39,47,55,63,62,61,60,59,58,57,56);

              
              for(i=0;i<valueof(Width);i=i+8)
                begin
                    for(j=0;j<valueof(Height);j=j+8)
                    begin
                        small_arr = cut_arr(ss_in,i,j);
                    for(k=0;k<wid*heit;k=k+1)
                        begin
                            small_temp[k/wid][k%heit]=small_arr[idx[k]/wid][idx[k]%heit];
                        end
                        ss_out = join_arr(ss_out,small_temp,i,j);
                    end
                end


              
                return ss_out;

    endfunction


module mkTest_ss(Ifc_io);



    method ActionValue#(Arr_16) io (Arr_16 ss_in);
        Arr_16 out = spiral(ss_in);
        return out;
    endmethod


endmodule

interface Axi4_layer;
    interface Ifc_io io;
    interface AXI4_Slave_IFC#(Two_d,Eight,Null) slave;
endinterface

(* synthesize *)
module  burst_wrapper(Axi4_layer);

Ifc_io small_spiral_out <- mkTest_ss; 

AXI4_Slave_Xactor_IFC#(Two_d,Eight,Null)   s_xactor <- mkAXI4_Slave_Xactor();



endmodule




endpackage


