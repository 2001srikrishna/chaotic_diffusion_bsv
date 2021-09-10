package image_bsv;

import Vector::*;
import FShow :: *;
import FloatingPoint :: *;

interface Ifc_io;
// method Action inp(t a);
endinterface
typedef 16 Width ;
typedef 16 Height ;
typedef 3 Dim ;
typedef TDiv#(Width,8) Chunk_Width ;
typedef TDiv#(Height,8) Chunk_Height ;

typedef TMul#(TMul#(Width,Height),Dim) SizeOfLengthReal ;
typedef TDiv#(SizeOfLengthReal,Dim) Two_d ;


typedef Bit#(8) One_byte;
typedef Vector#(16,Vector#(16,(One_byte))) Arr_16;
typedef Vector#(8,Vector#(8,(One_byte))) Arr_8;
//typedef Vector#(8,Vector#(8,Arr_8)) Arr_8;

// typedef (One_byte)[8][8] small_arr;

typedef Tuple3#(Arr_16,Arr_16,Arr_16) Arr_3d;
typedef Tuple3#(Vector#(Two_d,One_byte),Vector#(Two_d,One_byte),Vector#(Two_d,One_byte)) Three_2d;
typedef Tuple2#(Arr_3d,Three_2d) Lor_to_rc5;

(* synthesize *)
module mkEncryption(Ifc_io); 

//Integer Width = 16;
//Integer Height = 16;

//Integer Dim = 3;
//Integer SizeOfLengthReal = Width*Height*Dim;
//Integer Two_d = SizeOfLengthReal/Dim;

Vector#(SizeOfLengthReal,(One_byte)) total_memory;

Vector#(SizeOfLengthReal,(Bit#(10))) lor_map;

Vector#(SizeOfLengthReal,(One_byte)) temp_memory;

Vector#(SizeOfLengthReal,(One_byte)) ross_map;

Vector#(Two_d,(One_byte)) r;

Vector#(Two_d,(One_byte)) g;

Vector#(Two_d,(One_byte)) b;

Arr_16 ra;
Arr_16 ga;
Arr_16 ba;


Arr_8  blr;
Arr_8  blg;
Arr_8  blb;

//stmt/rule 
//ra=spiral(r);
//ga=spiral(g);
//ba=spiral(b);

// (One_byte) ss_in[Width][Height];
// (One_byte) small_arr[8][8];


function Arr_8 cut_arr(Arr_16 ss_in,Integer i,Integer j);

    Arr_8 small_arr;

    Integer wid = 8;
    Integer heit = 8;
        
    Integer k = 0;
    Integer l = 0;

        for(k=0;k<valueof(Chunk_Width);k=k+1)
            begin
                for(l=0;l<valueof(Chunk_Height);l=l+1)
                    begin
                        small_arr[k][l] = ss_in[i+k][j+l];
                    end
            end
    return small_arr;
endfunction

function Arr_16 join_arr(Arr_16 ss_16,Arr_8 ss_8,Integer i,Integer j);

    Integer wid = 8;
    Integer heit = 8;
    
    Integer k = 0;
    Integer l = 0;

            for(k=0;k<valueof(Chunk_Width);k=k+1)
            begin
                for(l=0;l<valueof(Chunk_Height);l=l+1)
                begin
                    ss_16[i+k][j+l] = ss_8[k][l];
                end
            end
    return ss_16;
endfunction

function Arr_16 spiral(Arr_16 ss_in);

        Arr_16 ss_out;
        Arr_8 small_arr;
        // (One_byte) temp[wid][valueof(Chunk_Height)] <- mkReg(0);

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

        Arr_8 small_temp ;

        for(i=0;i<valueof(Width);i=i+8)
        begin
            for(j=0;j<valueof(Height);j=j+8)
            begin
                small_arr = cut_arr(ss_in,i,j);

            while(ht<heit && bt<wid)
                begin
                        if(ht<heit)
                        begin
                            while(l<bt)
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
                            while(k<ht)
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
                            while(l>wid-bt-2)   
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
                            while(k>heit-ht-2)
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
        return ss_out;

endfunction

// Big spiral - each unit = 8X8 array
function Arr_16 big_spiral(Arr_16 ss_in);

        Vector#(Chunk_Width,Vector#(Chunk_Height,Arr_8)) big_chunk;
        Arr_16 ss_out;
        Arr_8 small_arr;

        Integer i = 0; 
        Integer j = 0;

        Integer k = valueof(Chunk_Width)/2-1;
        Integer l = valueof(Chunk_Height)/2-1;

        Integer x = 0;
        Integer y = 0;

        Integer ht = valueof(Chunk_Width)/2;
        Integer bt = valueof(Chunk_Height)/2;

        Vector#(Chunk_Width,Vector#(Chunk_Height,Arr_8)) big_chunk_temp ;

        for(i=0;i<valueof(Width);i=i+8)
        begin
            for(j=0;j<valueof(Height);j=j+8)
            begin
                big_chunk[i/8][j/8] = cut_arr(ss_in,i,j);
            end
        end

                while(ht<valueof(Chunk_Height) && bt<valueof(Chunk_Width))
                    begin
                        if(ht<valueof(Chunk_Height))
                        begin
                            while(l<bt)
                            begin
                                big_chunk_temp[x][y] = big_chunk[k][l]; 
                                l=l+1;
                                if(y<valueof(Chunk_Width)-1)
                                    y=y+1;
                                else
                                begin
                                    y=0;
                                    x=x+1;
                                end
                            end
                        end
                        
                        if(l<valueof(Chunk_Width))
                        begin
                            while(k<ht)
                            begin
                                big_chunk_temp[x][y] = big_chunk[k][l]; 
                                k=k+1;
                                if(y<valueof(Chunk_Width)-1)
                                    y=y+1;
                                else
                                begin
                                    y=0;
                                    x=x+1;
                                end 
                            end
                        end
                    
                        if(valueof(Chunk_Width)-bt>0)
                        begin
                            while(l>valueof(Chunk_Width)-bt-2)   
                            begin
                                big_chunk_temp[x][y] = big_chunk[k][l]; 
                                l=l-1;
                                if(y<valueof(Chunk_Width)-1)
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
                                while(k>valueof(Chunk_Height)-ht-2)
                                begin
                                    big_chunk_temp[x][y] = big_chunk[k][l]; 
                                    k=k-1;
                                    if(y<valueof(Chunk_Width)-1)
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

        for(i=0;i<valueof(Width);i=i+8)
        begin
            for(j=0;j<valueof(Height);j=j+8)
            begin
                ss_out = join_arr(ss_out,big_chunk_temp[i/8][j/8],i,j);
            end
        end
        return ss_out;
endfunction

function Integer bin_search(Vector#(Two_d,Float) a1,Float a);
    Integer beg = 0;
    Integer endd = valueof(Two_d)-1;
    Integer mid = (beg + endd)/2;

    Integer idx = 0;

    while(beg<=endd)
    begin
        mid = (beg + endd)/2;
        if(a>a1[mid])
        begin
            beg = mid + 1;
        end
        else if(a<a1[mid])
        begin
            endd = mid -1; 
        end
        else
        begin
            idx = mid;
        end
    end
        return idx;
endfunction

function Lor_to_rc5 lorentz_confusion(Arr_3d lor_in);



    Arr_16 lor_in_r = tpl_1(lor_in);
    Arr_16 lor_in_g = tpl_2(lor_in);
    Arr_16 lor_in_b = tpl_3(lor_in);

    Arr_16 lor_out_r ;
    Arr_16 lor_out_g ;
    Arr_16 lor_out_b ;

    

    Float a = unpack(32'h41200000); // 10
    Float b = unpack(32'h402aaaab); // 8/3
    Float c = unpack(32'h41e00000); // 28
    Float dt = unpack(32'h3a83126f); // 0.001

    Vector#(Two_d,Float) x;
    Vector#(Two_d,Float) y;
    Vector#(Two_d,Float) z;

    Vector#(Two_d,One_byte) x_reg;
    Vector#(Two_d,One_byte) y_reg;
    Vector#(Two_d,One_byte) z_reg;

    Vector#(Two_d,Float) x1;
    Vector#(Two_d,Float) y1;
    Vector#(Two_d,Float) z1;

    Float temp;

    Integer i;
    Integer j;

    Int#(64) v;

    Float prec_fact = unpack(32'h47c35000); //1E+5


            /*
            Paper name - www.elsevier.com/locate/optlaseng
        Optics and Lasers in Engineering - Journal - ElsevierOptics and Lasers in Engineering aims at providing an international forum for the interchange of information on the development of optical techniques and lase…www.elsevier.com​
            Salwa K. Abd-El-Hafiz a , Sherif H. AbdElHaleem a , Ahmed G. Radwan a,b, n

            lorentz algo is continuos chaos algo
        */

    x[0] = unpack(32'h40c96873); // 6.294
    y[0] = unpack(32'hc0d83127); // -6.756
    z[0] = unpack(32'h4038b439); // 2.886

    for(i=0;i<valueof(Two_d)-1;i=i+1)
    begin
        x[i+1]=x[i]+dt*a*(y[i]-x[i]);
        y[i+1]=y[i]+dt*(c*x[i+1]-y[i]-x[i+1]*z[i]);
        z[i+1]=z[i]+dt*(x[i+1]*y[i+1]-b*z[i]);
    end
    for(i=0;i<valueof(Two_d);i=i+1)
    begin
        v = tpl_1((vFloatToFixed(6'd0,x[i]*prec_fact,Rnd_Zero)));
        x_reg[i] = pack(v)[7:0];

        v = tpl_1((vFloatToFixed(6'd0,y[i]*prec_fact,Rnd_Zero)));
        y_reg[i] = pack(v)[7:0];

        v = tpl_1((vFloatToFixed(6'd0,z[i]*prec_fact,Rnd_Zero)));
        z_reg[i] = pack(v)[7:0];
    end

    x1 = x;
    y1 = y;
    z1 = z;

    Integer idx;

    // bubble sort
    for(i=0;i<valueof(Two_d)-1;i=i+1)
    begin
        for(j=0;j<valueof(Two_d)-i-1;j=j+1)
        begin
            if(x[i]>x[i+1])
            begin
                temp = x[i];
                x[i] = x[i+1];
                x[i+1] = temp;
            end

            if(y[i]>y[i+1])
            begin
                temp = y[i];
                y[i] = y[i+1];
                y[i+1] = temp;
            end

            if(z[i]>z[i+1])
            begin
                temp = z[i];
                z[i] = z[i+1];
                z[i+1] = temp;
            end
        end
    end

    // binary search
    for(i=0;i<valueof(Two_d);i=i+1)
    begin
        idx = bin_search(x1,x[i]);
        lor_out_r[i/valueof(Height)][i%valueof(Width)] = lor_in_r[idx/valueof(Height)][idx%valueof(Width)];
        idx = bin_search(y1,y[i]);
        lor_out_g[i/valueof(Height)][i%valueof(Width)] = lor_in_g[idx/valueof(Height)][idx%valueof(Width)];
        idx = bin_search(z1,z[i]);
        lor_out_b[i/valueof(Height)][i%valueof(Width)] = lor_in_b[idx/valueof(Height)][idx%valueof(Width)];
    end

    Arr_3d lor_out = tuple3(lor_out_r,lor_out_g,lor_out_b);
    Three_2d trunc_lor_seq = tuple3(x_reg,y_reg,z_reg);
    Lor_to_rc5 lor_out_rc5 = tuple2(lor_out,trunc_lor_seq);


    return lor_out_rc5;
endfunction

function Arr_3d rossler_diffusion(Arr_3d ros_in);
    Arr_16 ros_in_r = tpl_1(ros_in);
    Arr_16 ros_in_g = tpl_2(ros_in);
    Arr_16 ros_in_b = tpl_3(ros_in);

    Arr_16 ros_out_r;
    Arr_16 ros_out_g;
    Arr_16 ros_out_b;

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
    Integer tmp;
    for(i=0;i<valueof(Two_d);i=i+1)
    begin
        v = tpl_1((vFloatToFixed(6'd0,x[i]*prec_fact,Rnd_Zero)));
        x_reg[i] = pack(v)[7:0];

        v = tpl_1((vFloatToFixed(6'd0,y[i]*prec_fact,Rnd_Zero)));
        y_reg[i] = pack(v)[7:0];

        v = tpl_1((vFloatToFixed(6'd0,z[i]*prec_fact,Rnd_Zero)));
        z_reg[i] = pack(v)[7:0];
    end

    

    /*
    fl = 100000*fl%256;
    edo = pack(fl-frac(fl));
    */

    Arr_16 x_2d;
    Arr_16 y_2d;
    Arr_16 z_2d;

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

function One_byte circ_shift(One_byte in_byte,Bit#(3) zm); // right circular shift 

    Integer i;

    // One_byte out_byte;

    for(i=0;i<zm;i=i+1)
    begin
        in_byte = {in_byte[0],in_byte[7:1]};
    end

    return in_byte;
endfunction

function Arr_3d rc5_encryption(Lor_to_rc5 rc5_in);

    Arr_3d rc5_in_3d = tpl_1(rc5_in);
    Arr_16 rc5_in_r = tpl_1(rc5_in_3d);
    Arr_16 rc5_in_g = tpl_2(rc5_in_3d);
    Arr_16 rc5_in_b = tpl_3(rc5_in_3d);

    Three_2d trunc_seq = tpl_2(rc5_in);
    Vector#(Two_d,One_byte) lor_r = tpl_1(trunc_seq);
    Vector#(Two_d,One_byte) lor_g = tpl_2(trunc_seq);
    Vector#(Two_d,One_byte) lor_b = tpl_3(trunc_seq);

    Arr_16 rc5_out_r;
    Arr_16 rc5_out_g;
    Arr_16 rc5_out_b;

    Bit#(3) z;

    Integer i;
    Integer j;

    for(i=0;i<valueof(Width);i=i+1)
    begin
        for(j=0;j<valueof(Height);j=j+1)
        begin
            z = truncate(lor_r[i*valueof(Width)+j]%6 + 1); 
            rc5_out_r[i][j] = rc5_in_r[i][j]^lor_r[i*valueof(Width)+j]^((2**lor_r[i*valueof(Width)+j])%255); 
            rc5_out_r[i][j] = circ_shift(rc5_out_r[i][j],z);

            z = truncate(lor_g[i*valueof(Width)+j]%6 + 1); 
            rc5_out_g[i][j] = rc5_in_g[i][j]^lor_g[i*valueof(Width)+j]^((2**lor_g[i*valueof(Width)+j])%255); 
            rc5_out_g[i][j] = circ_shift(rc5_out_g[i][j],z);

            z = truncate(lor_b[i*valueof(Width)+j]%6 + 1); 
            rc5_out_b[i][j] = rc5_in_b[i][j]^lor_b[i*valueof(Width)+j]^((2**lor_b[i*valueof(Width)+j])%255); 
            rc5_out_b[i][j] = circ_shift(rc5_out_b[i][j],z);
        end
    end

    Arr_3d rc5_out = tuple3(rc5_out_r,rc5_out_g,rc5_out_b);

    return rc5_out;
endfunction

endmodule

endpackage
