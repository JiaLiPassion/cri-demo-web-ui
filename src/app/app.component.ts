import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
  title = 'CRI Demo';
  inputUrls: string;
  outputUrls: string[];

  constructor(private httpClient: HttpClient) {}

  process() {
    if (!this.inputUrls) {
      alert('Please input a valid url');
      return;
    }
    this.httpClient.get('assets/config/config.json').subscribe((config: any) => {
      this.httpClient
        .post(`${config.serverUrl}/recognize`, { image_urls: this.inputUrls.split('\n') })
        .subscribe((r: any) => {
          this.outputUrls = r.map(imgUrl => `${config.serverUrl}${imgUrl}`);
        });
    });
  }
}
