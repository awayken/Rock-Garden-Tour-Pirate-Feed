package com.runawaystar.rockgardentour;
import java.io.IOException;
import javax.servlet.http.*;

//@SuppressWarnings("serial")
public class Rock_Garden_Tour_Pirate_FeedServlet extends HttpServlet {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");
	}
}
