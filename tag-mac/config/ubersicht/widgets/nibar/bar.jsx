const style = {
  background: "#1D1D1D",
  cursor: "default",
  userSelect: "none",
  zIndex: "-1",
  width: "100%",
  height: "20px",
  position: "fixed",
  overflow: "hidden",
  top: "0px",
  right: "0px",
  left: "0px"
};

export const refreshFrequency = 1000000;

export const render = ({ output }) => {
  return <div style={style} />;
};

export default null;
