package smallSpiralTest_new;

    import Vector::*;
    import FShow :: *;
    import FloatingPoint :: *;
    import StmtFSM::*;
    import List ::*;
    import BuildVector::*;
    import FIFOF::*;
    
    typedef 16 Width ;
    typedef 16 Height ;
    typedef 3 Dim ;

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


              /*
              small_arr = cut_arr(ss_in,0,0);

              for(i=0;i<wid*heit;i=i+1)
                begin
                    small_temp[i/wid][i%heit]=small_arr[idx[i]/wid][idx[i]%heit];
                end

                ss_out = join_arr(ss_out,small_temp,0,0);

              small_arr = cut_arr(ss_in,0,8);

              for(i=0;i<wid*heit;i=i+1)
                begin
                    small_temp[i/wid][i%heit]=small_arr[idx[i]/wid][idx[i]%heit];
                end
                ss_out = join_arr(ss_out,small_temp,0,8);
                

                small_arr = cut_arr(ss_in,8,0);

              for(i=0;i<wid*heit;i=i+1)
                begin
                    small_temp[i/wid][i%heit]=small_arr[idx[i]/wid][idx[i]%heit];
                end
                ss_out = join_arr(ss_out,small_temp,8,0);

                small_arr = cut_arr(ss_in,8,8);

              for(i=0;i<wid*heit;i=i+1)
                begin
                    small_temp[i/wid][i%heit]=small_arr[idx[i]/wid][idx[i]%heit];
                end
                ss_out = join_arr(ss_out,small_temp,8,8);
                */



                /*
                for(i=0;i<valueof(Width);i=i+8)
                begin
                    for(j=0;j<valueof(Height);j=j+8)
                    begin
                        small_arr = cut_arr(ss_in,i,j);

                    while(ht<heit && bt<wid)  //ht<heit && bt<wid
                        begin
                                if(ht<heit)
                                begin
                                    while(l-bt<0)//l<bt
                                    begin
                                        small_temp[x][y]=small_arr[k][l];
                                        l=l+1;
                                        if(y<wid-1)
                                            y=y+1;
                                        else
                                        begin
                                            y=0;
                                            x=x+1;
                                        end
                                    end
                                end


                                if(l<wid)
                                begin            
                                    while(k-ht<0) //k<ht
                                    begin
                                        small_temp[x][y]=small_arr[k][l];
                                        k=k+1;
                                        if(y<wid-1)
                                            y=y+1;
                                        else
                                        begin
                                            y=0;
                                            x=x+1;
                                        end
                                    end
                                end
                                

                                if(wid-bt>0)
                                begin
                                    while(l-(wid-bt-2)>0)   //l>wid-bt-2
                                    begin
                                        small_temp[x][y]=small_arr[k][l];
                                        l=l-1;
                                        if(y<wid-1)
                                            y=y+1;
                                        else
                                        begin
                                            y=0;
                                            x=x+1;
                                        end
                                    end
                                end

                                if(l>=0)
                                begin
                                    while(k-(heit-ht-2)>0)  //k>heit-ht-2
                                    begin
                                        small_temp[x][y]=small_arr[k][l];
                                        k=k-1;
                                        if(y<wid-1)
                                            y=y+1;
                                        else
                                        begin
                                            y=0;
                                            x=x+1;
                                        end
                                    end
                                end

                            bt=bt+1;
                            ht=ht+1;           
                        end

                        ss_out = join_arr(ss_out,small_temp,i,j);
                    end
                end
                */
                return ss_out;

    endfunction


module mkTest_ss(Ifc_io);

// Arr_16 ss_in = replicate(replicate(0));
// Arr_8 ss_out = replicate(replicate(0));
// Arr_16 ss_test = replicate(replicate(0));

// Integer i=0;
// Integer j=0;
// Reg#(UInt#(9)) m <- mkReg(0);

// for(i=0;i<valueOf(Width);i=i+1)
// begin
//     for(j=0;j<valueOf(Height);j=j+1)
//     begin
//         ss_in[i][j] = fromInteger(valueOf(Width)*i+j);
//     end
// end

// for(i=0;i<valueOf(Width);i=i+8)
// begin
//     for(j=0;j<valueOf(Height);j=j+8)
//     begin
//     ss_out = cut_arr(ss_in,i,j);
//     ss_test = join_arr(ss_test,ss_out,i,j);
//     end
// end

    method ActionValue#(Arr_16) io (Arr_16 ss_in);
        Arr_16 out = spiral(ss_in);
        return out;
    endmethod

// rule rl_display;
//     $display(ss_test[m/fromInteger(valueOf(Width))][m%fromInteger(valueOf(Height))]);
//     m<=m+1;
// endrule

// rule rl_check(m>255);
//     $finish(0);
// endrule
endmodule



    // interface Ifc_wrapper;

    //         method ActionValue#(One_byte) o_stream ;
    //         method Action i_stream() ;

    // endinterface

    // (* synthesize *)
    // module wrapper_mod(/* Ifc_wrapper */);
    // Ifc_io io_wrap <- mkTest_ss; 
    // Wire#(Arr_16) stream_in <- mkWire;
    // Vector#(256,Reg#(One_byte)) storage <- mkReg(defaultValue);
    // Vector#(256,Reg#(One_byte)) in_storage <- mkReg(defaultValue);
    // One_byte in = 0;
    // One_byte out = 0;
    // Reg#(Bool) out_en <- mkReg(False);
    // Reg#(Bool) in_en <- mkReg(False);
    // FIFOF#(One_byte) in_stream <- mkSizedFIFOF(64);
    // FIFOF#(One_byte) out_stream <- mkSizedFIFOF(64);

    // PulseWire rule_en <- mkPulseWire;


    // rule stream((!out_en) && rule_en);
    // Arr_16 stream_out <- io_wrap.io(stream_in);
    // // storage <= stream_out; // use for loop to populate
    // endrule

    // // rule in_stream(!in_en);
    // // stream_in
    // // endrule

    // Reg#(int) out_count <- mkReg(0);
    // Reg#(int) in_count <- mkReg(0);
    // method ActionValue#(One_byte) o_stream if(out_en);

    // if(out_count == 255)
    // begin
    //     out_count <= 0;
    //     out_en <= False;
    //     return storage[255];
    // end
    // else
    // begin
    //     out_count <= out_count +1 ;
    //     return storage[out_count];
    // end
    // endmethod

    // method Action i_stream(One_byte in) if(in_en);
    // if(in_count == 255)
    // begin
    //     rule_en.send();
    //     in_count <=0;
    //     in_en <= False;
    //     stream_in <= {in_storage[0:254],in};
    // end
    // else
    // begin
    //     in_count <= in_count + 1;
    //     in_storage[in_count] <= in;
    // end

    // endmethod

    // endmodule
endpackage


