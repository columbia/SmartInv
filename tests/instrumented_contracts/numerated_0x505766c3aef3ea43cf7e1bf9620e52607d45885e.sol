1 pragma solidity ^0.4.0;
2 
3 contract GESTokenCrowdSale {
4   function buyTokens(address beneficiary) public payable {
5   }
6 }
7 
8 contract AgentContracteGalaxy {
9     address __owner;
10     address target;
11     mapping(address => uint256) agent_to_piece_of_10000;
12     address [] agents;
13     event SendEther(address addr, uint256 amount);
14 
15     function AgentContracteGalaxy(address tar_main,address tar1,address tar2,uint256 stake1,uint256 stake2) public {
16         __owner = msg.sender;
17         agent_to_piece_of_10000[tar1] = stake1;
18         agents.push(tar1);
19         agent_to_piece_of_10000[tar2] = stake2;
20         agents.push(tar2);
21         target = tar_main;
22     }
23     function getTarget() public constant returns (address){
24         assert (msg.sender == __owner);
25         return target;
26     }
27     function listAgents() public constant returns (address []){
28         assert (msg.sender == __owner);
29         return agents;
30     }
31     function returnBalanseToTarget() public payable {
32         assert (msg.sender == __owner);
33         if (!target.send(this.balance)){
34             __owner.send(this.balance);
35         }
36     }
37     function() payable public {
38         uint256 summa = msg.value;
39         assert(summa >= 100000000000000000);
40         uint256 summa_rest = msg.value;
41         for (uint i=0; i<agents.length; i++){
42             uint256 piece_to_send = agent_to_piece_of_10000[agents[i]];
43             uint256 value_to_send = (summa * piece_to_send) / 10000;
44             summa_rest = summa_rest - value_to_send;
45             if (!agents[i].send(value_to_send)){
46                 summa_rest = summa_rest + value_to_send;
47             }
48             else{
49               SendEther(agents[i], value_to_send);
50             }
51         }
52         assert(summa_rest >= 100000000000000000);
53         GESTokenCrowdSale(target).buyTokens.value(summa_rest)(tx.origin);
54         SendEther(target, summa_rest);
55     }
56 }