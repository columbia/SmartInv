1 pragma solidity ^0.4.6;
2 
3 contract DesafioStone {
4 
5   function DesafioStone() {}
6 
7   function o_aprendiz(uint a) constant returns (uint) {
8     return a == 42 ? 1 : 0;
9   }
10   
11   function o_algoritmo(uint a) constant returns (uint) {
12     uint s = 0;
13     for (uint i = 0; i < 21; ++i)
14       s += i;
15     return a == s / 5 ? 1 : 0;
16   }
17 
18   function a_incognita(uint x) constant returns (uint) {
19     return x*x*x + 3*x*x + 3*x + 7 == 2395346478 ? 1 : 0;
20   }
21 
22   function a_empresa(bytes5 nome) constant returns (uint) {
23     return sha3(nome) == 0x7cdf2c59fd49fab5ebabf1630c3a1f4d5c22c0aaa3651ca37dd688a69b33f3aa ? 1 : 0;
24   }
25 
26   function o_desafiante(bytes14 nome) constant returns (uint) {
27     return sha3(nome) == 0x71c6223d42fee2811e6f2ccfbb7bc5d1c57d47a97f9cbb8b2aedd67c312dc367 ? 1 : 0;
28   }
29 
30   function a_palavra(bytes5 palavra) constant returns (uint) {
31     return sha3(palavra) == 0x2e4588766bcfa3508dfb56a344fd7b1c3eca4954b2b8b795ab02209396528367 ? 2 : 0;
32   }
33 
34   function o_velho_problema(uint a, uint b) constant returns (uint) {
35     return a * b == 239811736052687 ? 2 : 0;
36   }
37 
38   function o_novo_problema(uint x) constant returns (uint) {
39     return 3 ** x == 0x5dd085b1f9816a47e96bf6f50b6717456ce772886c3e6686e020a456dc1a3623 ? 2 : 0;
40   }
41 
42   function o_minerador(uint a) constant returns (uint) {
43     bytes32 hash = sha3(a);
44     for (uint i = 0; i < 32; ++i)
45       if (hash[i] != 0)
46         break;
47     return i;
48   }
49 
50   function o_automata(uint inicio) constant returns (uint) {
51     uint[ 8] memory r = [uint(0),1,0,1,1,0,1,0];
52     uint[16] memory x = [uint(0),1,1,0,0,1,1,0,0,1,1,0,0,1,1,0];
53     uint[16] memory y = [uint(0),0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
54 
55     for (uint k = 0; k < 16; ++k)
56       x[k] = inicio / (2 ** k) % 2;
57 
58     for (uint t = 0; t < 8; ++t) {
59       for (uint p = 0; p < 16; ++p)
60         y[p] = r[(p == 0 ? 0 : x[p-1]) + x[p] * 2 + (p == 15 ? 0 : x[p+1]) * 4];
61       for (uint q = 0; q < 16; ++q)
62         x[q] = y[q];
63     }
64 
65     uint s = 0;
66     for (uint i = 0; i < 16; ++i)
67       s += x[i];
68 
69     return s <= 9 ? 0 : s <= 13 ? 1 : s <= 15 ? 4 : 8;
70   }
71 
72   function o_labirinto(uint acoes) constant returns (uint) {
73     uint map = 0xfff8800882288008c048fdf8e038e838e138fdf8f9f8fbf8fff8000000000000;
74     uint x = 6;
75     uint y = 11;
76 
77     for (uint i = 0; i < 64; ++i) {
78       uint acao = acoes / (2 ** (256 - (i+1)*4)) % 0x10;
79 
80       if (acao == 0) y -= 1;
81       if (acao == 1) x += 1;
82       if (acao == 2) y += 1;
83       if (acao == 3) x -= 1;
84 
85       uint index = 2 ** (255 - (y * 16 + x));
86 
87       if (map / index % 2 == 1)
88         break;
89 
90       map = map + index;
91     }
92 
93     return i / 8;
94   }
95 
96   function o_deus(bytes32 a, bytes32 b) constant returns (uint) {
97     return a != b && sha3(a) == sha3(b) ? 999999999 : 0;
98   }
99 
100   function responder
101     ( uint a
102     , uint b
103     , uint c
104     , bytes5 d
105     , bytes14 e
106     , bytes5 f
107     , uint g
108     , uint h
109     , uint i
110     , uint j
111     , uint k
112     , uint l
113     ) {
114     uint pontos = 0;
115     pontos += o_aprendiz(a);
116     pontos += o_algoritmo(b);
117     pontos += a_incognita(c);
118     pontos += a_empresa(d);
119     pontos += o_desafiante(e);
120     pontos += a_palavra(f);
121     pontos += o_velho_problema(g, h);
122     pontos += o_novo_problema(i);
123     pontos += o_minerador(j);
124     pontos += o_automata(k);
125     pontos += o_labirinto(l);
126     address desafiado = 0xD12A749b6585Cb7605Aeb89455CD33aAeda1EbDB;
127     if (pontos >= 20)
128       if (desafiado.send(this.balance))
129         return;
130   }
131 
132   function() payable {}
133 
134 }