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
12         require(keccak256(human_readable_blockhash[0]) == keccak256(""));
13         _;
14     }
15     
16     function record_human_readable_blockhash() 
17         one_time_use public
18     {
19         bytes6[] memory word_sequence = new bytes6[](wordcount);
20         word_sequence = wordbot_contract.getWords(wordcount);
21         
22         for(uint i = 0; i<wordcount; i++) {
23             bytes6 word = word_sequence[i];
24             bytes memory toBytes = new bytes(6);
25             assembly {
26                 toBytes := mload(word)
27             }
28             human_readable_blockhash[i] = string(toBytes);
29         }
30         
31     }
32     
33 }