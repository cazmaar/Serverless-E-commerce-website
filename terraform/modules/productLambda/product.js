exports.handler = async (event) => {
  const res =  {
    statusCode: 200,
    "headers": { 
      "Content-Type": "application/json" },
    body: `Hello World ${event.path}`,
  };
  return JSON.stringify(res)
};
