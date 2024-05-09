1 // all purpose suicide contract 
2 
3 contract LetsSuicide{
4     constructor(address LetsFuckingSuicide) payable {
5         suicide(LetsFuckingSuicide);
6     }
7 }
8 
9 contract SuicideContract{
10     function NukeContract(address Russian) payable {
11         (new LetsSuicide).value(msg.value)(Russian);
12     }
13 }