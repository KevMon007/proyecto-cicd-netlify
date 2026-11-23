export const handler = async (event, context) => {
  return {
    statusCode: 200,
    headers: {
      "Content-Type": "application/json; charset=utf-8",
      "Cache-Control": "no-store"
    },
    body: JSON.stringify({
      status: "ok",
      service: "proyecto-cicd-netlify",
      timestamp: new Date().toISOString(),
      environment: process.env.CONTEXT || "production"
    })
  };
};