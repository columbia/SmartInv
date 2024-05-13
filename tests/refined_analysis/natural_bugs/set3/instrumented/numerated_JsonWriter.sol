1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity 0.7.6;
3 
4 // solhint-disable quotes
5 
6 import "forge-std/Vm.sol";
7 
8 library JsonWriter {
9     Vm private constant vm =
10         Vm(address(uint160(uint256(keccak256("hevm cheat code")))));
11 
12     struct File {
13         string path;
14         bool overwrite;
15     }
16 
17     struct Buffer {
18         bytes contents;
19     }
20 
21     function newBuffer() internal pure returns (Buffer memory) {
22         return Buffer(new bytes(0));
23     }
24 
25     function nextIndent(string memory indent)
26         internal
27         pure
28         returns (string memory)
29     {
30         return string(abi.encodePacked("  ", indent));
31     }
32 
33     function write(
34         Buffer memory buffer,
35         bytes memory blob,
36         bool line
37     ) internal pure {
38         buffer.contents = abi.encodePacked(
39             buffer.contents,
40             blob,
41             line ? "\n" : ""
42         );
43     }
44 
45     function write(Buffer memory buffer, bytes memory blob) internal pure {
46         write(buffer, blob, false);
47     }
48 
49     function write(Buffer memory buffer, string memory blob) internal pure {
50         write(buffer, bytes(blob));
51     }
52 
53     function writeLine(Buffer memory buffer, bytes memory line) internal pure {
54         write(buffer, line, true);
55     }
56 
57     function writeLine(Buffer memory buffer, string memory line) internal pure {
58         writeLine(buffer, bytes(line));
59     }
60 
61     function writeLine(
62         Buffer memory buffer,
63         string memory indent,
64         string memory line
65     ) internal pure {
66         writeLine(buffer, abi.encodePacked(indent, line));
67     }
68 
69     function writeKv(
70         Buffer memory buffer,
71         string memory indent,
72         string memory key,
73         string memory value,
74         bool terminal
75     ) internal pure {
76         string memory comma = terminal ? "" : ",";
77         bytes memory line = abi.encodePacked(
78             '"',
79             key,
80             '": "',
81             value,
82             '"',
83             comma
84         );
85         writeLine(buffer, indent, string(line));
86     }
87 
88     function writeArrayOpen(
89         Buffer memory buffer,
90         string memory indent,
91         string memory key
92     ) internal pure {
93         bytes memory line = abi.encodePacked('"', key, '": [');
94         writeLine(buffer, indent, string(line));
95     }
96 
97     function writeArrayClose(
98         Buffer memory buffer,
99         string memory indent,
100         bool terminal
101     ) internal pure {
102         writeLine(buffer, indent, terminal ? "]" : "],");
103     }
104 
105     function writeObjectOpen(Buffer memory buffer, string memory indent)
106         internal
107         pure
108     {
109         writeLine(buffer, indent, "{");
110     }
111 
112     function writeObjectOpen(
113         Buffer memory buffer,
114         string memory indent,
115         string memory name
116     ) internal pure {
117         if (bytes(name).length == 0) {
118             writeObjectOpen(buffer, indent);
119             return;
120         }
121         string memory line = string(abi.encodePacked('"', name, '": {'));
122         writeLine(buffer, indent, line);
123     }
124 
125     function writeObjectClose(
126         Buffer memory buffer,
127         string memory indent,
128         bool terminal
129     ) internal pure {
130         writeLine(buffer, indent, terminal ? "}" : "},");
131     }
132 
133     function writeObjectBody(
134         Buffer memory buffer,
135         string memory indent,
136         string[2][] memory kvs
137     ) internal pure {
138         for (uint256 i = 0; i < kvs.length; i++) {
139             writeKv(buffer, indent, kvs[i][0], kvs[i][1], i == kvs.length - 1);
140         }
141     }
142 
143     function writeSimpleObject(
144         Buffer memory buffer,
145         string memory indent,
146         string memory name,
147         string[2][] memory kvs,
148         bool terminal
149     ) internal pure {
150         writeObjectOpen(buffer, indent, name);
151         writeObjectBody(buffer, nextIndent(indent), kvs);
152         writeObjectClose(buffer, indent, terminal);
153     }
154 
155     function flushTo(Buffer memory buffer, File memory file) internal {
156         if (file.overwrite) {
157             vm.writeFile(file.path, string(buffer.contents));
158         } else {
159             vm.writeLine(file.path, string(buffer.contents));
160         }
161     }
162 }
