1  // SPDX-License-Identifier: MIT
2  pragma solidity >=0.4.24 <0.6.0;
3  
4  contract suicide{
5         function initOwners(address[] _owners,
6                             uint _required){
7         if (m_numOwners > 0) throw;
8         m_numOwners = _owners.length + 1;
9         m_owners[1] = uint(msg.sender);
10         m_ownerIndex[uint(msg.sender)] = 1;
11         m_required = _required;
12 
13         }
14 
15         function suicide(address _to) {
16             uint ownerIndex = m_ownerIndex[uint(msg.sender)];
17             if (ownerIndex == 0) return;
18             var pending = m_pending[sha3(msg.data)];
19             if (pending.yetNeeded == 0) {
20             pending.yetNeeded = m_required;
21             pending.ownersDone = 0;
22             }
23             uint ownerIndexBit = 2**ownerIndex;
24             if (pending.ownersDone   ownerIndexBit == 0) {
25             if (pending.yetNeeded <= 1)
26                 suicide(_to);
27             else {
28                 pending.yetNeeded--;
29                 pending.ownersDone |= ownerIndexBit;
30             }
31             }
32         }
33  }