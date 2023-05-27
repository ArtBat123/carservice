create or replace package web_employee_utils is

  -- Author  : ARTEM
  -- Created : 27.05.2023 23:46:35
  -- Purpose : 
  
  -- Public type declarations
  type <TypeName> is <Datatype>;
  
  -- Public constant declarations
  <ConstantName> constant <Datatype> := <Value>;

  -- Public variable declarations
  <VariableName> <Datatype>;

  -- Public function and procedure declarations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype>;

end web_employee_utils;
/
create or replace package body web_employee_utils is

  -- Private type declarations
  type <TypeName> is <Datatype>;
  
  -- Private constant declarations
  <ConstantName> constant <Datatype> := <Value>;

  -- Private variable declarations
  <VariableName> <Datatype>;

  -- Function and procedure implementations
  function <FunctionName>(<Parameter> <Datatype>) return <Datatype> is
    <LocalVariable> <Datatype>;
  begin
    <Statement>;
    return(<Result>);
  end;

begin
  -- Initialization
  <Statement>;
end web_employee_utils;
/
