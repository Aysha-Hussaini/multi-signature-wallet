pragma solidity ^0.4.10;

contract MultiSigWallet{
   struct Transaction {
      address recipient;
      uint value;
      bytes data;
      bool executed;
      uint confirmations;
   }

   Transaction[] public transactions; 
   address[] public owners;
   uint public requiredConfirmations;
   mapping(address => bool) public isOwner;
   mapping (uint => mapping(address => bool)) public isConfirmed;

   modifier checkOwner(){
      require(isOwner[msg.sender], "not an owner");
      _;
   }

   modifier txExists(uint _txID){
      require(transactions[_txId].recipient != 0,"Transaction does not exist");
      _;
   }

   modifier txExecuted(uint _txID){
      require(!transactions[_txID].executed, "Transaction already executed");
      _;
   }

   modifier txConfirmed(uint _txID) {
      require(!isConfirmed[_txID][msg.sender], "Transaction already confirmed by this owner");
      _;
   }

   /// @dev Constructor
   constructor (address[] memory _owners, uint _requiredConfirmations) public {
      require(_owners.length >0, "Owners are required");
      require(r_equiredConfirmations >0 && _requiredConfirmations <=owners.length, "Invalid confirmations");

      for (uint i=0;i < _owners.length; i++){
         address owner = _owners[i];

         owners.push(owner);
         isOwner[owner] = true;
      }
      requiredConfirmations = _requiredConfirmations;
   }

   function submitTransaction(address _recipient, uint _value, bytes _data) public 
      checkOwner returns(uint)
   {
      transactions.push(
         Transaction({
            recipient: _recipient,
            value: _value,
            data: _data,
            executed: false,
            confirmations: 0
         });
         uint txID = transactions.length;
         return txID
      )
   }

   function confirmTransaction(uint _txID) public 
      checkOwner
      txExists(_txID)
      txExecuted(_txID)
      txConfirmed(_txID)
   {
   
      Transation storage transaction = transactions[_txID]
      transaction[_txID].confirmations += 1;
      isConfirmed[_txID][msg.sender] =true;
      
   }

   function executeTransaction(uint _txID) public 
      checkOwner
      txExists(_txID)
      txExecuted(_txID)
      txConfirmed(_txID)
   {
      require(transactions[_txID].confirmations >= requiredConfirmations, "Not enough confirmations")
      transactions[_txID].executed = true;
   }

   function revokeConfirmation(uint _txID) public
      checkOwner
      txExists(_txID)
      txExecuted(_txID)
      txConfirmed(_txID)
   {
      require (isConfirmed[_txID][msg.sender],"Transaction not confirmed")
      transactions[_txID].confirmations -= 1;
      isConfirmed[_txID][msg.sender] = false;
   }

   function getOwners() public view returns(address[] memory){
      return owners;
   }

   function getTransaction() public view returns(
      address recipient,
      uint value,
      bytes data,
      bool executed,
      uint confirmations
   )
   {
      Transaction storage transaction = transactions[_txID]
      return(
         transaction.recipient,
         transaction.value,
         transaction.data,
         transaction.executed,
         transaction.confirmations,
      );      
   }
}