1 pragma solidity ^0.4.24;
2 
3 contract wordbot { function getWords(uint _wordcount) public view returns (bytes6[]) {} }
4 
5 contract test {
6     wordbot wordbot_contract = wordbot(0xA95E23ac202ad91204DA8C1A24B55684CDcC19B3);
7     
8     uint wordcount = 12;
9     string[12] public human_readable_blockhash;
10     
11     modifier one_time_use {
12         require(keccak256(abi.encodePacked(human_readable_blockhash[0])) == keccak256(abi.encodePacked("")));
13         _;
14     }
15     
16 
17     function record_human_readable_blockhash() 
18         one_time_use public
19     {
20         bytes6[] memory word_sequence = new bytes6[](wordcount);
21         word_sequence = wordbot_contract.getWords(wordcount);
22         
23         for(uint i = 0; i<wordcount; i++) {
24             bytes6 word = word_sequence[i];
25             bytes memory toBytes = new bytes(6);
26             
27             toBytes[0] = word[0];
28             toBytes[1] = word[1];
29             toBytes[2] = word[2];
30             toBytes[3] = word[3];
31             toBytes[4] = word[4];
32             toBytes[5] = word[5];
33 
34             string memory toString = string(toBytes);
35             human_readable_blockhash[i] = toString;
36         }
37     }
38 }