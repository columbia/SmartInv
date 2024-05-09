1 pragma solidity ^0.4.0;
2 
3 contract AgentContract {
4 
5     address __owner;
6     address target;
7     mapping(address => uint256) agent_to_piece_of_10000;
8     address [] agents;
9     event SendEther(address addr, uint256 amount);
10 
11     function AgentContract(address tar_main,address tar1,address tar2,uint256 stake1,uint256 stake2) public {
12         __owner = msg.sender;
13         agent_to_piece_of_10000[tar1] = stake1;
14         agents.push(tar1);
15         agent_to_piece_of_10000[tar2] = stake2;
16         agents.push(tar2);
17         target = tar_main;
18     }
19     function getTarget() public constant returns (address){
20         assert (msg.sender == __owner);
21         return target;
22     }
23     function listAgents() public constant returns (address []){
24         assert (msg.sender == __owner);
25         return agents;
26     }
27     function returnBalanseToTarget() public payable {
28         assert (msg.sender == __owner);
29         if (!target.send(this.balance)){
30             __owner.send(this.balance);
31         }
32     }
33     function() payable public {
34         uint256 summa = msg.value;
35         assert(summa >= 10000);
36         uint256 summa_rest = msg.value;
37         for (uint i=0; i<agents.length; i++){
38             uint256 piece_to_send = agent_to_piece_of_10000[agents[i]];
39             uint256 value_to_send = (summa * piece_to_send) / 10000;
40             summa_rest = summa_rest - value_to_send;
41             if (!agents[i].send(value_to_send)){
42                 summa_rest = summa_rest + value_to_send;
43             }
44             else{
45               SendEther(agents[i], value_to_send);
46             }
47         }
48         if (!target.send(summa_rest)){
49             if (!msg.sender.send(summa_rest)){
50                 __owner.send(summa_rest);
51                 SendEther(__owner, summa_rest);
52             }
53             else{
54               SendEther(msg.sender, summa_rest);
55             }
56         }
57         else{
58           SendEther(target, summa_rest);
59         }
60     }
61 }