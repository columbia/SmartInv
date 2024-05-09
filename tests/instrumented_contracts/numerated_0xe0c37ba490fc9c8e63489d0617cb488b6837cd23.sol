1 pragma solidity ^0.4.21;
2 
3 contract primoContratto {
4     address private proprietario;
5     mapping (uint256 => string) private frasi;
6     uint256 private frasiTotali = 0;
7     
8     function primoContratto() public {
9         proprietario = msg.sender;
10     }
11     
12     function aggiungiFrase(string _frase) public returns (uint256) {
13         frasi[frasiTotali] = _frase;
14         frasiTotali++;
15         return frasiTotali-1;
16     }
17     
18     function totaleFrasi() public view returns (uint256) {
19         return frasiTotali;
20     }
21     
22     function leggiFrase(uint256 _numeroFrase) public view returns (string) {
23         return frasi[_numeroFrase];
24     }
25     
26     function kill() public {
27         if (proprietario != msg.sender) return;
28         selfdestruct(proprietario);
29     }
30 }