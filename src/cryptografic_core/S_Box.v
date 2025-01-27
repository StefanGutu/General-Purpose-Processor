module S_Box(
    input clk, rst, cript, decript,
    input [7:0] old_val,
    output reg  [7:0] new_val
);


    always @(posedge clk,negedge rst) begin
        if(!rst) begin
            new_val <= 8'b0;
        end
        else begin
            if (cript == 1'b1) begin
                case (old_val)
                    8'h00: new_val<=8'h63;
                    8'h01: new_val<=8'h7c;
                    8'h02: new_val<=8'h77;
                    8'h03: new_val<=8'h7b;
                    8'h04: new_val<=8'hf2;
                    8'h05: new_val<=8'h6b;
                    8'h06: new_val<=8'h6f;
                    8'h07: new_val<=8'hc5;
                    8'h08: new_val<=8'h30;
                    8'h09: new_val<=8'h01;
                    8'h0a: new_val<=8'h67;
                    8'h0b: new_val<=8'h2b;
                    8'h0c: new_val<=8'hfe;
                    8'h0d: new_val<=8'hd7;
                    8'h0e: new_val<=8'hab;
                    8'h0f: new_val<=8'h76;
                    8'h10: new_val<=8'hca;
                    8'h11: new_val<=8'h82;
                    8'h12: new_val<=8'hc9;
                    8'h13: new_val<=8'h7d;
                    8'h14: new_val<=8'hfa;
                    8'h15: new_val<=8'h59;
                    8'h16: new_val<=8'h47;
                    8'h17: new_val<=8'hf0;
                    8'h18: new_val<=8'had;
                    8'h19: new_val<=8'hd4;
                    8'h1a: new_val<=8'ha2;
                    8'h1b: new_val<=8'haf;
                    8'h1c: new_val<=8'h9c;
                    8'h1d: new_val<=8'ha4;
                    8'h1e: new_val<=8'h72;
                    8'h1f: new_val<=8'hc0;
                    8'h20: new_val<=8'hb7;
                    8'h21: new_val<=8'hfd;
                    8'h22: new_val<=8'h93;
                    8'h23: new_val<=8'h26;
                    8'h24: new_val<=8'h36;
                    8'h25: new_val<=8'h3f;
                    8'h26: new_val<=8'hf7;
                    8'h27: new_val<=8'hcc;
                    8'h28: new_val<=8'h34;
                    8'h29: new_val<=8'ha5;
                    8'h2a: new_val<=8'he5;
                    8'h2b: new_val<=8'hf1;
                    8'h2c: new_val<=8'h71;
                    8'h2d: new_val<=8'hd8;
                    8'h2e: new_val<=8'h31;
                    8'h2f: new_val<=8'h15;
                    8'h30: new_val<=8'h04;
                    8'h31: new_val<=8'hc7;
                    8'h32: new_val<=8'h23;
                    8'h33: new_val<=8'hc3;
                    8'h34: new_val<=8'h18;
                    8'h35: new_val<=8'h96;
                    8'h36: new_val<=8'h05;
                    8'h37: new_val<=8'h9a;
                    8'h38: new_val<=8'h07;
                    8'h39: new_val<=8'h12;
                    8'h3a: new_val<=8'h80;
                    8'h3b: new_val<=8'he2;
                    8'h3c: new_val<=8'heb;
                    8'h3d: new_val<=8'h27;
                    8'h3e: new_val<=8'hb2;
                    8'h3f: new_val<=8'h75;
                    8'h40: new_val<=8'h09;
                    8'h41: new_val<=8'h83;
                    8'h42: new_val<=8'h2c;
                    8'h43: new_val<=8'h1a;
                    8'h44: new_val<=8'h1b;
                    8'h45: new_val<=8'h6e;
                    8'h46: new_val<=8'h5a;
                    8'h47: new_val<=8'ha0;
                    8'h48: new_val<=8'h52;
                    8'h49: new_val<=8'h3b;
                    8'h4a: new_val<=8'hd6;
                    8'h4b: new_val<=8'hb3;
                    8'h4c: new_val<=8'h29;
                    8'h4d: new_val<=8'he3;
                    8'h4e: new_val<=8'h2f;
                    8'h4f: new_val<=8'h84;
                    8'h50: new_val<=8'h53;
                    8'h51: new_val<=8'hd1;
                    8'h52: new_val<=8'h00;
                    8'h53: new_val<=8'hed;
                    8'h54: new_val<=8'h20;
                    8'h55: new_val<=8'hfc;
                    8'h56: new_val<=8'hb1;
                    8'h57: new_val<=8'h5b;
                    8'h58: new_val<=8'h6a;
                    8'h59: new_val<=8'hcb;
                    8'h5a: new_val<=8'hbe;
                    8'h5b: new_val<=8'h39;
                    8'h5c: new_val<=8'h4a;
                    8'h5d: new_val<=8'h4c;
                    8'h5e: new_val<=8'h58;
                    8'h5f: new_val<=8'hcf;
                    8'h60: new_val<=8'hd0;
                    8'h61: new_val<=8'hef;
                    8'h62: new_val<=8'haa;
                    8'h63: new_val<=8'hfb;
                    8'h64: new_val<=8'h43;
                    8'h65: new_val<=8'h4d;
                    8'h66: new_val<=8'h33;
                    8'h67: new_val<=8'h85;
                    8'h68: new_val<=8'h45;
                    8'h69: new_val<=8'hf9;
                    8'h6a: new_val<=8'h02;
                    8'h6b: new_val<=8'h7f;
                    8'h6c: new_val<=8'h50;
                    8'h6d: new_val<=8'h3c;
                    8'h6e: new_val<=8'h9f;
                    8'h6f: new_val<=8'ha8;
                    8'h70: new_val<=8'h51;
                    8'h71: new_val<=8'ha3;
                    8'h72: new_val<=8'h40;
                    8'h73: new_val<=8'h8f;
                    8'h74: new_val<=8'h92;
                    8'h75: new_val<=8'h9d;
                    8'h76: new_val<=8'h38;
                    8'h77: new_val<=8'hf5;
                    8'h78: new_val<=8'hbc;
                    8'h79: new_val<=8'hb6;
                    8'h7a: new_val<=8'hda;
                    8'h7b: new_val<=8'h21;
                    8'h7c: new_val<=8'h10;
                    8'h7d: new_val<=8'hff;
                    8'h7e: new_val<=8'hf3;
                    8'h7f: new_val<=8'hd2;
                    8'h80: new_val<=8'hcd;
                    8'h81: new_val<=8'h0c;
                    8'h82: new_val<=8'h13;
                    8'h83: new_val<=8'hec;
                    8'h84: new_val<=8'h5f;
                    8'h85: new_val<=8'h97;
                    8'h86: new_val<=8'h44;
                    8'h87: new_val<=8'h17;
                    8'h88: new_val<=8'hc4;
                    8'h89: new_val<=8'ha7;
                    8'h8a: new_val<=8'h7e;
                    8'h8b: new_val<=8'h3d;
                    8'h8c: new_val<=8'h64;
                    8'h8d: new_val<=8'h5d;
                    8'h8e: new_val<=8'h19;
                    8'h8f: new_val<=8'h73;
                    8'h90: new_val<=8'h60;
                    8'h91: new_val<=8'h81;
                    8'h92: new_val<=8'h4f;
                    8'h93: new_val<=8'hdc;
                    8'h94: new_val<=8'h22;
                    8'h95: new_val<=8'h2a;
                    8'h96: new_val<=8'h90;
                    8'h97: new_val<=8'h88;
                    8'h98: new_val<=8'h46;
                    8'h99: new_val<=8'hee;
                    8'h9a: new_val<=8'hb8;
                    8'h9b: new_val<=8'h14;
                    8'h9c: new_val<=8'hde;
                    8'h9d: new_val<=8'h5e;
                    8'h9e: new_val<=8'h0b;
                    8'h9f: new_val<=8'hdb;
                    8'ha0: new_val<=8'he0;
                    8'ha1: new_val<=8'h32;
                    8'ha2: new_val<=8'h3a;
                    8'ha3: new_val<=8'h0a;
                    8'ha4: new_val<=8'h49;
                    8'ha5: new_val<=8'h06;
                    8'ha6: new_val<=8'h24;
                    8'ha7: new_val<=8'h5c;
                    8'ha8: new_val<=8'hc2;
                    8'ha9: new_val<=8'hd3;
                    8'haa: new_val<=8'hac;
                    8'hab: new_val<=8'h62;
                    8'hac: new_val<=8'h91;
                    8'had: new_val<=8'h95;
                    8'hae: new_val<=8'he4;
                    8'haf: new_val<=8'h79;
                    8'hb0: new_val<=8'he7;
                    8'hb1: new_val<=8'hc8;
                    8'hb2: new_val<=8'h37;
                    8'hb3: new_val<=8'h6d;
                    8'hb4: new_val<=8'h8d;
                    8'hb5: new_val<=8'hd5;
                    8'hb6: new_val<=8'h4e;
                    8'hb7: new_val<=8'ha9;
                    8'hb8: new_val<=8'h6c;
                    8'hb9: new_val<=8'h56;
                    8'hba: new_val<=8'hf4;
                    8'hbb: new_val<=8'hea;
                    8'hbc: new_val<=8'h65;
                    8'hbd: new_val<=8'h7a;
                    8'hbe: new_val<=8'hae;
                    8'hbf: new_val<=8'h08;
                    8'hc0: new_val<=8'hba;
                    8'hc1: new_val<=8'h78;
                    8'hc2: new_val<=8'h25;
                    8'hc3: new_val<=8'h2e;
                    8'hc4: new_val<=8'h1c;
                    8'hc5: new_val<=8'ha6;
                    8'hc6: new_val<=8'hb4;
                    8'hc7: new_val<=8'hc6;
                    8'hc8: new_val<=8'he8;
                    8'hc9: new_val<=8'hdd;
                    8'hca: new_val<=8'h74;
                    8'hcb: new_val<=8'h1f;
                    8'hcc: new_val<=8'h4b;
                    8'hcd: new_val<=8'hbd;
                    8'hce: new_val<=8'h8b;
                    8'hcf: new_val<=8'h8a;
                    8'hd0: new_val<=8'h70;
                    8'hd1: new_val<=8'h3e;
                    8'hd2: new_val<=8'hb5;
                    8'hd3: new_val<=8'h66;
                    8'hd4: new_val<=8'h48;
                    8'hd5: new_val<=8'h03;
                    8'hd6: new_val<=8'hf6;
                    8'hd7: new_val<=8'h0e;
                    8'hd8: new_val<=8'h61;
                    8'hd9: new_val<=8'h35;
                    8'hda: new_val<=8'h57;
                    8'hdb: new_val<=8'hb9;
                    8'hdc: new_val<=8'h86;
                    8'hdd: new_val<=8'hc1;
                    8'hde: new_val<=8'h1d;
                    8'hdf: new_val<=8'h9e;
                    8'he0: new_val<=8'he1;
                    8'he1: new_val<=8'hf8;
                    8'he2: new_val<=8'h98;
                    8'he3: new_val<=8'h11;
                    8'he4: new_val<=8'h69;
                    8'he5: new_val<=8'hd9;
                    8'he6: new_val<=8'h8e;
                    8'he7: new_val<=8'h94;
                    8'he8: new_val<=8'h9b;
                    8'he9: new_val<=8'h1e;
                    8'hea: new_val<=8'h87;
                    8'heb: new_val<=8'he9;
                    8'hec: new_val<=8'hce;
                    8'hed: new_val<=8'h55;
                    8'hee: new_val<=8'h28;
                    8'hef: new_val<=8'hdf;
                    8'hf0: new_val<=8'h8c;
                    8'hf1: new_val<=8'ha1;
                    8'hf2: new_val<=8'h89;
                    8'hf3: new_val<=8'h0d;
                    8'hf4: new_val<=8'hbf;
                    8'hf5: new_val<=8'he6;
                    8'hf6: new_val<=8'h42;
                    8'hf7: new_val<=8'h68;
                    8'hf8: new_val<=8'h41;
                    8'hf9: new_val<=8'h99;
                    8'hfa: new_val<=8'h2d;
                    8'hfb: new_val<=8'h0f;
                    8'hfc: new_val<=8'hb0;
                    8'hfd: new_val<=8'h54;
                    8'hfe: new_val<=8'hbb;
                    8'hff: new_val<=8'h16;
                endcase
            end
            if(decript == 1'b1) begin
                case(old_val)
                    8'h00:new_val<=8'h52;
                    8'h01:new_val<=8'h09;
                    8'h02:new_val<=8'h6a;
                    8'h03:new_val<=8'hd5;
                    8'h04:new_val<=8'h30;
                    8'h05:new_val<=8'h36;
                    8'h06:new_val<=8'ha5;
                    8'h07:new_val<=8'h38;
                    8'h08:new_val<=8'hbf;
                    8'h09:new_val<=8'h40;
                    8'h0a:new_val<=8'ha3;
                    8'h0b:new_val<=8'h9e;
                    8'h0c:new_val<=8'h81;
                    8'h0d:new_val<=8'hf3;
                    8'h0e:new_val<=8'hd7;
                    8'h0f:new_val<=8'hfb;
                    8'h10:new_val<=8'h7c;
                    8'h11:new_val<=8'he3;
                    8'h12:new_val<=8'h39;
                    8'h13:new_val<=8'h82;
                    8'h14:new_val<=8'h9b;
                    8'h15:new_val<=8'h2f;
                    8'h16:new_val<=8'hff;
                    8'h17:new_val<=8'h87;
                    8'h18:new_val<=8'h34;
                    8'h19:new_val<=8'h8e;
                    8'h1a:new_val<=8'h43;
                    8'h1b:new_val<=8'h44;
                    8'h1c:new_val<=8'hc4;
                    8'h1d:new_val<=8'hde;
                    8'h1e:new_val<=8'he9;
                    8'h1f:new_val<=8'hcb;
                    8'h20:new_val<=8'h54;
                    8'h21:new_val<=8'h7b;
                    8'h22:new_val<=8'h94;
                    8'h23:new_val<=8'h32;
                    8'h24:new_val<=8'ha6;
                    8'h25:new_val<=8'hc2;
                    8'h26:new_val<=8'h23;
                    8'h27:new_val<=8'h3d;
                    8'h28:new_val<=8'hee;
                    8'h29:new_val<=8'h4c;
                    8'h2a:new_val<=8'h95;
                    8'h2b:new_val<=8'h0b;
                    8'h2c:new_val<=8'h42;
                    8'h2d:new_val<=8'hfa;
                    8'h2e:new_val<=8'hc3;
                    8'h2f:new_val<=8'h4e;
                    8'h30:new_val<=8'h08;
                    8'h31:new_val<=8'h2e;
                    8'h32:new_val<=8'ha1;
                    8'h33:new_val<=8'h66;
                    8'h34:new_val<=8'h28;
                    8'h35:new_val<=8'hd9;
                    8'h36:new_val<=8'h24;
                    8'h37:new_val<=8'hb2;
                    8'h38:new_val<=8'h76;
                    8'h39:new_val<=8'h5b;
                    8'h3a:new_val<=8'ha2;
                    8'h3b:new_val<=8'h49;
                    8'h3c:new_val<=8'h6d;
                    8'h3d:new_val<=8'h8b;
                    8'h3e:new_val<=8'hd1;
                    8'h3f:new_val<=8'h25;
                    8'h40:new_val<=8'h72;
                    8'h41:new_val<=8'hf8;
                    8'h42:new_val<=8'hf6;
                    8'h43:new_val<=8'h64;
                    8'h44:new_val<=8'h86;
                    8'h45:new_val<=8'h68;
                    8'h46:new_val<=8'h98;
                    8'h47:new_val<=8'h16;
                    8'h48:new_val<=8'hd4;
                    8'h49:new_val<=8'ha4;
                    8'h4a:new_val<=8'h5c;
                    8'h4b:new_val<=8'hcc;
                    8'h4c:new_val<=8'h5d;
                    8'h4d:new_val<=8'h65;
                    8'h4e:new_val<=8'hb6;
                    8'h4f:new_val<=8'h92;
                    8'h50:new_val<=8'h6c;
                    8'h51:new_val<=8'h70;
                    8'h52:new_val<=8'h48;
                    8'h53:new_val<=8'h50;
                    8'h54:new_val<=8'hfd;
                    8'h55:new_val<=8'hed;
                    8'h56:new_val<=8'hb9;
                    8'h57:new_val<=8'hda;
                    8'h58:new_val<=8'h5e;
                    8'h59:new_val<=8'h15;
                    8'h5a:new_val<=8'h46;
                    8'h5b:new_val<=8'h57;
                    8'h5c:new_val<=8'ha7;
                    8'h5d:new_val<=8'h8d;
                    8'h5e:new_val<=8'h9d;
                    8'h5f:new_val<=8'h84;
                    8'h60:new_val<=8'h90;
                    8'h61:new_val<=8'hd8;
                    8'h62:new_val<=8'hab;
                    8'h63:new_val<=8'h00;
                    8'h64:new_val<=8'h8c;
                    8'h65:new_val<=8'hbc;
                    8'h66:new_val<=8'hd3;
                    8'h67:new_val<=8'h0a;
                    8'h68:new_val<=8'hf7;
                    8'h69:new_val<=8'he4;
                    8'h6a:new_val<=8'h58;
                    8'h6b:new_val<=8'h05;
                    8'h6c:new_val<=8'hb8;
                    8'h6d:new_val<=8'hb3;
                    8'h6e:new_val<=8'h45;
                    8'h6f:new_val<=8'h06;
                    8'h70:new_val<=8'hd0;
                    8'h71:new_val<=8'h2c;
                    8'h72:new_val<=8'h1e;
                    8'h73:new_val<=8'h8f;
                    8'h74:new_val<=8'hca;
                    8'h75:new_val<=8'h3f;
                    8'h76:new_val<=8'h0f;
                    8'h77:new_val<=8'h02;
                    8'h78:new_val<=8'hc1;
                    8'h79:new_val<=8'haf;
                    8'h7a:new_val<=8'hbd;
                    8'h7b:new_val<=8'h03;
                    8'h7c:new_val<=8'h01;
                    8'h7d:new_val<=8'h13;
                    8'h7e:new_val<=8'h8a;
                    8'h7f:new_val<=8'h6b;
                    8'h80:new_val<=8'h3a;
                    8'h81:new_val<=8'h91;
                    8'h82:new_val<=8'h11;
                    8'h83:new_val<=8'h41;
                    8'h84:new_val<=8'h4f;
                    8'h85:new_val<=8'h67;
                    8'h86:new_val<=8'hdc;
                    8'h87:new_val<=8'hea;
                    8'h88:new_val<=8'h97;
                    8'h89:new_val<=8'hf2;
                    8'h8a:new_val<=8'hcf;
                    8'h8b:new_val<=8'hce;
                    8'h8c:new_val<=8'hf0;
                    8'h8d:new_val<=8'hb4;
                    8'h8e:new_val<=8'he6;
                    8'h8f:new_val<=8'h73;
                    8'h90:new_val<=8'h96;
                    8'h91:new_val<=8'hac;
                    8'h92:new_val<=8'h74;
                    8'h93:new_val<=8'h22;
                    8'h94:new_val<=8'he7;
                    8'h95:new_val<=8'had;
                    8'h96:new_val<=8'h35;
                    8'h97:new_val<=8'h85;
                    8'h98:new_val<=8'he2;
                    8'h99:new_val<=8'hf9;
                    8'h9a:new_val<=8'h37;
                    8'h9b:new_val<=8'he8;
                    8'h9c:new_val<=8'h1c;
                    8'h9d:new_val<=8'h75;
                    8'h9e:new_val<=8'hdf;
                    8'h9f:new_val<=8'h6e;
                    8'ha0:new_val<=8'h47;
                    8'ha1:new_val<=8'hf1;
                    8'ha2:new_val<=8'h1a;
                    8'ha3:new_val<=8'h71;
                    8'ha4:new_val<=8'h1d;
                    8'ha5:new_val<=8'h29;
                    8'ha6:new_val<=8'hc5;
                    8'ha7:new_val<=8'h89;
                    8'ha8:new_val<=8'h6f;
                    8'ha9:new_val<=8'hb7;
                    8'haa:new_val<=8'h62;
                    8'hab:new_val<=8'h0e;
                    8'hac:new_val<=8'haa;
                    8'had:new_val<=8'h18;
                    8'hae:new_val<=8'hbe;
                    8'haf:new_val<=8'h1b;
                    8'hb0:new_val<=8'hfc;
                    8'hb1:new_val<=8'h56;
                    8'hb2:new_val<=8'h3e;
                    8'hb3:new_val<=8'h4b;
                    8'hb4:new_val<=8'hc6;
                    8'hb5:new_val<=8'hd2;
                    8'hb6:new_val<=8'h79;
                    8'hb7:new_val<=8'h20;
                    8'hb8:new_val<=8'h9a;
                    8'hb9:new_val<=8'hdb;
                    8'hba:new_val<=8'hc0;
                    8'hbb:new_val<=8'hfe;
                    8'hbc:new_val<=8'h78;
                    8'hbd:new_val<=8'hcd;
                    8'hbe:new_val<=8'h5a;
                    8'hbf:new_val<=8'hf4;
                    8'hc0:new_val<=8'h1f;
                    8'hc1:new_val<=8'hdd;
                    8'hc2:new_val<=8'ha8;
                    8'hc3:new_val<=8'h33;
                    8'hc4:new_val<=8'h88;
                    8'hc5:new_val<=8'h07;
                    8'hc6:new_val<=8'hc7;
                    8'hc7:new_val<=8'h31;
                    8'hc8:new_val<=8'hb1;
                    8'hc9:new_val<=8'h12;
                    8'hca:new_val<=8'h10;
                    8'hcb:new_val<=8'h59;
                    8'hcc:new_val<=8'h27;
                    8'hcd:new_val<=8'h80;
                    8'hce:new_val<=8'hec;
                    8'hcf:new_val<=8'h5f;
                    8'hd0:new_val<=8'h60;
                    8'hd1:new_val<=8'h51;
                    8'hd2:new_val<=8'h7f;
                    8'hd3:new_val<=8'ha9;
                    8'hd4:new_val<=8'h19;
                    8'hd5:new_val<=8'hb5;
                    8'hd6:new_val<=8'h4a;
                    8'hd7:new_val<=8'h0d;
                    8'hd8:new_val<=8'h2d;
                    8'hd9:new_val<=8'he5;
                    8'hda:new_val<=8'h7a;
                    8'hdb:new_val<=8'h9f;
                    8'hdc:new_val<=8'h93;
                    8'hdd:new_val<=8'hc9;
                    8'hde:new_val<=8'h9c;
                    8'hdf:new_val<=8'hef;
                    8'he0:new_val<=8'ha0;
                    8'he1:new_val<=8'he0;
                    8'he2:new_val<=8'h3b;
                    8'he3:new_val<=8'h4d;
                    8'he4:new_val<=8'hae;
                    8'he5:new_val<=8'h2a;
                    8'he6:new_val<=8'hf5;
                    8'he7:new_val<=8'hb0;
                    8'he8:new_val<=8'hc8;
                    8'he9:new_val<=8'heb;
                    8'hea:new_val<=8'hbb;
                    8'heb:new_val<=8'h3c;
                    8'hec:new_val<=8'h83;
                    8'hed:new_val<=8'h53;
                    8'hee:new_val<=8'h99;
                    8'hef:new_val<=8'h61;
                    8'hf0:new_val<=8'h17;
                    8'hf1:new_val<=8'h2b;
                    8'hf2:new_val<=8'h04;
                    8'hf3:new_val<=8'h7e;
                    8'hf4:new_val<=8'hba;
                    8'hf5:new_val<=8'h77;
                    8'hf6:new_val<=8'hd6;
                    8'hf7:new_val<=8'h26;
                    8'hf8:new_val<=8'he1;
                    8'hf9:new_val<=8'h69;
                    8'hfa:new_val<=8'h14;
                    8'hfb:new_val<=8'h63;
                    8'hfc:new_val<=8'h55;
                    8'hfd:new_val<=8'h21;
                    8'hfe:new_val<=8'h0c;
                    8'hff:new_val<=8'h7d;
				endcase
            end
        end
        
    end

endmodule



module sbox_tb;

    // Testbench signals
    reg clk;
    reg rst;
    reg cript;
    reg decript;
    reg [7:0] old_val;
    wire [7:0] new_val;

    // Instantiate the SBox module
    S_Box uut (
        .clk(clk),
        .rst(rst),
        .cript(cript),
        .decript(decript),
        .old_val(old_val),
        .new_val(new_val)
    );


    always #50 clk = ~clk;

    // Test procedure
    initial begin
        // Initialize signals
        rst = 0; cript = 0; decript = 0; old_val = 8'b0;
        clk = 0;
        
        // Apply reset
        $display("Applying Reset");
        #5 rst = 1;
        #100;
        // Test encryption
        $display("Testing Encryption");
        old_val = 8'h3C; 
        cript = 1; 
        #100;

        // Test decryption
        $display("Testing Decryption");
        old_val = 8'hEB; 
        cript = 0; 
        decript = 1;
        #100;

        $display("Testing Encryption");
        old_val = 8'h41; 
        cript = 1; 
        decript = 0;
        #100;

        // Test decryption
        $display("Testing Decryption");
        old_val = 8'h83; 
        cript = 0; 
        decript = 1;
        #100;
        
        // Finish simulation
        $stop;
    end

    // Monitor signals for debugging
    initial begin
        $monitor("cript: %b | decript: %b | old_val: %h | new_val: %h",
                 cript, decript, old_val, new_val);
    end

endmodule
