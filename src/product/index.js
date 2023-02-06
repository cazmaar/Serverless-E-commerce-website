export const handler = async (event) => {
  console.log("ADE")
  return {
    statusCode: 200,
    headers: { "content-Type": "text/plain" },
    body: `Hello World ${event.path}`,
  };
};
